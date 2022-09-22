class TableCustomersController < ApplicationController
  before_action :set_table_customer, only: [:show, :edit, :update, :destroy,:split_evenly, :split_by_items, :checkout, :pay_all, :card_roulette, :ordered!, :confirmation]
  before_action :set_restaurant, only: [:index, :show, :new, :create, :split_evenly, :split_by_items, :checkout, :pay_all, :card_roulette]
  before_action :set_table, only: [:index, :show, :new, :create, :checkout, :split_evenly, :split_by_items, :pay_all, :card_roulette]
  before_action :set_table_order, only: [:index, :show, :new, :create, :checkout, :split_evenly, :split_by_items, :pay_all, :card_roulette]

  def index
    @table_customers = TableCustomer.all
  end

  def show
  end

  def new
    @table_customer = TableCustomer.new
  end

  def create
    # Needs work
    @table_customer = TableCustomer.new(table_customer_params)
    @table_customer.is_captain = true if params[:table_customer][:is_captain] == "false"

    @table_order.user = User.where(is_owner: false).sample
    @table_customer.table_order_id = @table_order.id

    @table_customer.table_order = @table_order

    if @table_customer.save
      redirect_to new_restaurant_table_table_order_table_customer_order_item_path(@restaurant, @table, @table_order, @table_customer)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def split_evenly
    number = @table_order.table_customers.count
    splitted_bill = (@table_order.total_price.to_f / number).round(2)
    total_amount = (splitted_bill * 1.125).round(2)

    @table_order.table_customers.each do |customer|
      customer.update(amount_due: splitted_bill.to_f)
      customer.update(total_amount: total_amount.to_f)
    end
    @table_order.update(payment_option: "split_evenly")
    redirect_to checkout_path(@restaurant, @table, @table_order, @table_customer)
  end

  def split_by_items
    total_amount = (@table_customer.amount_due.to_f * 1.125).round(2)
    @table_customer.update(total_amount: total_amount.to_f)
    @table_order.update(payment_option: "split_by_items")
    redirect_to checkout_path(@restaurant, @table, @table_order, @table_customer)
  end

  def pay_all
    @payment_customer = TableCustomer.find(params[:payment_customer_id])
    table_amount = (@table_order.total_price * 1.125).round(2)
    @payment_customer.update(amount_due: @table_order.total_price)
    @payment_customer.update(total_amount: table_amount)
    @table_order.update(payment_option: "pay_all")
    @other_customers = @table_order.table_customers.select { |customer| customer.id != @payment_customer.id }
    unless @other_customers.nil?
      @other_customers.each do |customer|
        customer.update(amount_due: 0.to_f)
        customer.update(total_amount: 0.to_f)
      end
    end

    if @table_customer == @payment_customer
      redirect_to checkout_path(@restaurant, @table, @table_order, @payment_customer)
    else
      redirect_to confirmation_path()
    end
  end

  def card_roulette
    @payment_customer = TableCustomer.find(params[:payment_customer_id])
    table_amount = (@table_order.total_price * 1.125).round(2)
    @payment_customer.update(amount_due: @table_order.total_price.to_f)
    @payment_customer.update(total_amount: table_amount.to_f)
    @table_order.update(payment_option: "card_roulette")
    @other_customers = @table_order.table_customers.select { |customer| customer.id != @payment_customer.id }
    unless @other_customers.nil?
      @other_customers.each do |customer|
        customer.update(amount_due: 0.to_f)
        customer.update(total_amount: 0.to_f)
      end
    end

    if @table_customer == @payment_customer
      redirect_to checkout_path(@restaurant, @table, @table_order, @payment_customer)
    else
      redirect_to confirmation_path()
    end
  end

  def checkout
    # order  = Order.create!(teddy: teddy, teddy_sku: teddy.sku, amount: teddy.price, state: 'pending', user: current_user)
    @payment_customer = TableCustomer.find(params[:id])
    @table_price = @table_customer.total_amount.to_f
    @subtotal = @table_customer.amount_due.to_f
    @service_charge = (@subtotal * 0.125).round(2)
    @tip = (@subtotal * 0.0).round(2)
    @tax = (@subtotal - (@subtotal / 1.2)).round(2)

    # @table_customer.order_items.each do |order|
    #   table_price += order.menu_item.price
    # end
    @restaurant = @table_customer.table_order.restaurant
    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
        price_data: {
          currency: 'usd',
          unit_amount: (@table_price * 100).to_i,
          product_data: {
            name: 'Your order',
            description: 'Food',
            images: ['https://example.com/t-shirt.png'],
          },
        },
        quantity: 1
      }],
      mode: 'payment',
      success_url: "http://www.billy-961.com/restaurants/#{@restaurant.id}/tables/#{@table.id}/table_orders/#{@table_order.id}/table_customers/#{@table_customer.id}/confirmation",
      cancel_url: "http://www.billy-961.com/restaurants/#{@restaurant.id}/tables/#{@table.id}/table_orders/#{@table_order.id}/table_customers/#{@table_customer.id}/checkout",
    )

    @table_customer.update(checkout_session_id: session.id)
    # redirect_to checkout_path(@restaurant, @table, @table_order)
  end

  def confirmation
    @restaurant = Restaurant.find(params[:restaurant_id])
    @table_order = TableOrder.find(params[:table_order_id])
    @table = Table.find(params[:table_id])
    @table_order.update(is_active: false)
    @table.update(is_active: false)
  end

  def ordered!
    @table_order = @table_customer.table_order
    @table_customer.order_items.where(is_ordered: false).each do |item|
      item.update(is_ordered: true)
      customer_new_amount = @table_customer.amount_due.to_f + item.menu_item.price
      table_order_new_amount = @table_order.total_price.to_f + item.menu_item.price
      @table_customer.update(amount_due: customer_new_amount.round(2))
      @table_order.update(total_price: table_order_new_amount.round(2))
    end

    redirect_to restaurant_table_table_order_table_customer_order_items_path(
      @table_customer.restaurant,
      @table_customer.table,
      @table_customer.table_order,
      @table_customer
    )
  end

  private

  def set_table_customer
    @table_customer = TableCustomer.find(params[:id])
  end

  def set_table_order
    @table_order = TableOrder.find(params[:table_order_id])
  end

  def set_table
    @table = Table.find(params[:table_id])
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def table_customer_params
    # Needs work
    params.require(:table_customer).permit(:name, :is_captain, :is_paid)
  end
end
