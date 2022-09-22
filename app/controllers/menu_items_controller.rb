class MenuItemsController < ApplicationController
  before_action :set_restaurant, only: %i[index show new create edit update destroy]
  before_action :set_menu_item, only: %i[edit update destroy]

  def index
    # We might need this not sure yet
    @menu_item = MenuItem.all
  end

  def show
  end

  def new
    @menu_item = MenuItem.new
  end

  def create
    @menu_item = MenuItem.new(menu_item_params)
    @menu_item.restaurant = @restaurant
    if @menu_item.save
      redirect_to restaurant_path(@restaurant)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # We might also need an edit method TBD
  end

  def update
    @menu_item.update(menu_item_params)
    # redirect_to new_restaurant_menu_path(@restaurant)
  end

  def destroy
    @menu_item.destroy
    redirect_to restaurant_path(@menu_item.restaurant), status: :see_other
  end

  private

  def menu_item_params
    params.require(:menu_item).permit(:name, :category, :description, :price, :prepare_time, :photo)
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def set_menu_item
    @menu_item = MenuItem.find(params[:id])
  end
end
