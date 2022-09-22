class MenusController < ApplicationController
  before_action :set_restaurant, only: %i[index show new create edit update destroy activated!]
  before_action :set_menu, only: %i[show edit update destroy activated!]

  def index
    @menus = Menu.all
  end

  def show
    @join_menus = @menu.join_menus
  end

  def new
    @menu = Menu.new
  end

  def create
    @menu = Menu.new(menu_params)
    @menu.is_active = true if @restaurant.menus.count.zero?
    @menu.restaurant = @restaurant
    if @menu.save
      redirect_to restaurant_path(@restaurant)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # We might also need an edit method TBD
  end

  def update
    @menu.update(menu_params)
    redirect_to restaurant_menu_path(@restaurant, @menu)
  end

  def destroy
    @menu.destroy
    redirect_to restaurant_path(@menu.restaurant), status: :see_other
  end

  def activated!
    @menus = Menu.all
    @menus.each do |menu|
      menu.update(is_active: false)
    end
    @menu.update(is_active: true)
    redirect_to restaurant_menu_path(@restaurant, @menu)
  end

  private

  def menu_params
    params.require(:menu).permit(:name, :photo)
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def set_menu
    @menu = Menu.find(params[:id])
  end
end
