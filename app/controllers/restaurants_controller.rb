class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: %i[show kitchen edit update destroy]

  def index
    @restaurants = Restaurant.all
  end

  def show
    @referer = request.referer
  end

  def kitchen
    @food_tickets = @restaurant.order_items.select { |item| item.is_ordered == true && item.is_prepared == false }.sort_by(&:id)
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.user = User.find_by(is_owner: true)
    if @restaurant.save
      redirect_to restaurant_path(@restaurant)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @restaurant = Restaurant.new
  end

  def update
    @restaurant.update(restaurant_params)
    redirect_to restaurant_path(@restaurant)
  end

  def destroy
    @restaurant.destroy
    redirect_to restaurants_path, status: :see_other
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  end

  def restaurant_params
    params.require(:restaurant).permit(:name, :address, :phone_number, :theme_color, :photo)
  end
end
