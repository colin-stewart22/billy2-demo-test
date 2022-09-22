class OrderItemsController < ApplicationController
  before_action :set_order_item, only: %i[update destroy prepared! served!]

  def index
    @restaurant = Restaurant.find(params[:restaurant_id])
    @table = Table.find(params[:table_id])
    @table_order = TableOrder.find(params[:table_order_id])
    @table_customers = @table_order.table_customers
    @table_customer = TableCustomer.find(params[:table_customer_id])
  end

  def show
    @table_customer = TableCustomer.find(params[:table_customer_id])
  end

  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @menu = @restaurant.menus.select(&:is_active).first
    @table = Table.find(params[:table_id])
    @table_order = TableOrder.find(params[:table_order_id])
    @table_customer = TableCustomer.find(params[:table_customer_id])
    @table_customers = TableCustomer.where(table_order: @table_order)
    @order_item = OrderItem.new

    # @menu_items = @menu.menu_items.select { |item| item.category == category }

    if params[:category].present?
      if params[:category] == "Breakfast"
        @menu_items = @menu.menu_items.where(category: "Breakfast")
      elsif params[:category] == "Lunch"
        @menu_items = @menu.menu_items.where(category: "Lunch")
      elsif params[:category] == "Dinner"
        @menu_items = @menu.menu_items.where(category: "Dinner")
      elsif params[:category] == "Starters"
        @menu_items = @menu.menu_items.where(category: "Starters")
      elsif params[:category] == "Mains"
        @menu_items = @menu.menu_items.where(category: "Mains")
      elsif params[:category] == "Desserts"
        @menu_items = @menu.menu_items.where(category: "Desserts")
      elsif params[:category] == "Drinks"
        @menu_items = @menu.menu_items.where(category: "Drinks")
      end
    else
      @menu_items = @menu.menu_items
    end
  end

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @menu = @restaurant.menus.select(&:is_active).first
    @table = Table.find(params[:table_id])
    @table_order = TableOrder.find(params[:table_order_id])
    @table_customer = TableCustomer.find(params[:table_customer_id])
    @order_item = OrderItem.new(order_item_params)
    @order_item.table_customer = @table_customer
    @menu_item = @order_item.menu_item
    @order_item.estimated_serving_time = @menu_item.prepare_time

    @order_item.save!

    redirect_to new_restaurant_table_table_order_table_customer_order_item_path(
      @restaurant,
      @table,
      @table_order,
      @table_customer
    )
  rescue ActiveRecord::RecordInvalid
    render_new
  end

  def update
  end

  def destroy
    @order_item = OrderItem.find(params[:id])
    @table_customer = @order_item.table_customer
    @table_order = @order_item.table_order
    @order_item.destroy
    customer_new_amount = @table_customer.amount_due - @order_item.menu_item.price
    table_order_new_amount = @table_order.total_price - @order_item.menu_item.price
    @table_customer.update(amount_due: customer_new_amount.round(2))
    @table_order.update(total_price: table_order_new_amount.round(2))
    redirect_to restaurant_table_table_order_table_customer_path(
      @order_item.restaurant,
      @order_item.table,
      @order_item.table_order,
      @order_item.table_customer
    ), status: :see_other
  end

  def prepared!
    @order_item.update(is_prepared: true)
    redirect_to kitchen_path(@order_item.restaurant)
  end

  def served!
    @order_item.update(is_served: true)
    redirect_to server_path(@order_item.restaurant, @order_item.user)
  end

  def bool_to_ready(value)
    "<span class='bg-red-500 px-3 py-2 text-white text-sm rounded-lg'>Ready</span>".html_safe if value
  end

  private

  def order_item_params
    params.require(:order_item).permit(:note, :menu_item_id)
  end

  def set_order_item
    @order_item = OrderItem.find(params[:id])
  end

  def render_new
    @order_item = OrderItem.new
    render :new, status: :unprocessable_entity
  end
end
