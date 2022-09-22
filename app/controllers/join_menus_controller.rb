class JoinMenusController < ApplicationController
  before_action :set_restaurant, only: %i[new create]
  before_action :set_menu, only: %i[show new create]
  def show
    @join_menus = JoinMenu.where(menu_id: @menu.id)
  end

  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @join_menu = JoinMenu.new
  end

  def create
    @menu_items = MenuItem.where(id: params.dig(:join_menu, :menu_item_id))
    return render_new if @menu_items.empty?

    ActiveRecord::Base.transaction do
      @menu_items.each do |item|
        @join_menu = JoinMenu.new(menu: @menu, menu_item: item)
        @join_menu.save!
      end
      redirect_to new_restaurant_menu_join_menu_path(@restaurant, @menu, @join_menu)
    end
  rescue ActiveRecord::RecordInvalid
    render_new
  end

  def destroy
    @join_menu = JoinMenu.find(params[:id])
    session[:return_to] ||= request.referer
    @join_menu.destroy
    redirect_to session.delete(:return_to), status: :see_other
  end

  private

  def joinmenu_params
    params.require(:join_menu).permit(menu_item_ids: [])
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def set_menu
    @menu = Menu.find(params[:menu_id])
  end

  def render_new
    @join_menu = JoinMenu.new
    @join_menu.errors.add(:base, "It already exists")
    render :new, status: :unprocessable_entity
  end
end
