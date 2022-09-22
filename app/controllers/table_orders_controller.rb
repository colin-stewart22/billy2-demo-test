class TableOrdersController < ApplicationController
  before_action :set_table_order, only: [:show, :edit, :update, :destroy]
  before_action :set_restaurant, only: [:server, :new, :create]
  before_action :set_table, only: [:new, :create]

  def index
    @table_orders = TableOrder.all
  end

  def server
    @table_orders = TableOrder.where(user_id: params[:user_id])
  end

  def show
    @table_orders = TableOrder.find(params[:id])
  end

  def new
    if @table.table_orders.any?(&:is_active)
      @table_order = TableOrder.find_by(is_active: true)
      redirect_to new_restaurant_table_table_order_table_customer_path(@restaurant, @table, @table_order)
    else
      @table_order = TableOrder.new
    end
  end

  # def checkout
  #   @table_order = TableOrder.find(params[:id])
  #   @restaurant = @table_order.restaurant
  #   @table = @table_order.table
  #   # order  = Order.create!(teddy: teddy, teddy_sku: teddy.sku, amount: teddy.price, state: 'pending', user: current_user)
  #   table_price = 0

  #   @table_order.order_items.each do |order|
  #    table_price += order.menu_item.price
  #   end

  #   session = Stripe::Checkout::Session.create(
  #     payment_method_types: ['card'],
  #     line_items: [{
  #       price_data: {
  #         currency: 'usd',
  #         unit_amount: table_price.to_i * 100,
  #         product_data: {
  #           name: 'T-shirt',
  #           description: 'Comfortable cotton t-shirt',
  #           images: ['https://example.com/t-shirt.png'],
  #         },
  #       },
  #       quantity: 1,
  #     }],
  #     mode: 'payment',
  #     success_url: "http://127.0.0.1:3000/restaurants/#{@restaurant.id}/tables/#{@table.id}/table_orders/#{@table_order.id}/confirmation",
  #     cancel_url: "http://127.0.0.1:3000/restaurants/#{@restaurant.id}/tables/#{@table.id}/table_orders/#{@table_order.id}/checkout",
  #   )

  #   @table_order.update(checkout_session_id: session.id)
  #   # redirect_to checkout_path(@restaurant, @table, @table_order)
  # end

  def create
    @table_order = TableOrder.new(table_order_params)
    @table_order.is_active = true
    # @table_order.is_active = true if params[:table_order][:is_active] == "false"

    @table_order.user = User.find_by(first_name: "Mario")
    @table_order.table = @table
    if @table_order.save
      @table.update(is_active: true)
      redirect_to new_restaurant_table_table_order_table_customer_path(@restaurant, @table, @table_order)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @table_order = TableOrder.new
  end

  def update
    @table_order.update(table_order_params)
    redirect_to table_order_path(@table_order)
  end

  def destroy
    @table_order.destroy
    redirect_to table_orders_path, status: :see_other
  end

  private

  def set_table_order
    @table_order = TableOrder.find(params[:id])
  end

  def set_table
    @table = Table.find(params[:table_id])
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def table_order_params
    # Needs work
    params.require(:table_order).permit(:is_active)
  end
end
