class TablesController < ApplicationController
  before_action :set_table, only: [:show, :edit, :update, :destroy]
  before_action :set_restaurant, only: [:index, :new, :create]

  def index
    @tables = Table.all
    @qr_codes = {}
    @tables.each do |table|
      @qr_code = RQRCode::QRCode.new(table.qr_code)
      @svg = @qr_code.as_svg(
        offset: 0,
        color: '000',
        shape_rendering: 'crispEdges',
        standalone: true,
        module_size: 5
      )
      @qr_codes["#{table.table_number}"] = @svg
    end
  end

  def show
    @qr_code = RQRCode::QRCode.new(@table.qr_code)
    @svg = @qr_code.as_svg(
      offset: 0,
      color: '000',
      shape_rendering: 'crispEdges',
      standalone: true,
      module_size: 2
    )
  end

  def new
    @table = Table.new
    @table_number = Table.last.id + 1

  end

  def create
    @table = Table.new(table_params)
    @table.restaurant = @restaurant

    @table.qr_code = RQRCode::QRCode.new(@table.qr_code)
    # @svg = @qr_code.as_svg(
    #   offset: 0,
    #   color: '000',
    #   shape_rendering: 'crispEdges',
    #   standalone: true,
    #   module_size: 2
    # )
    if @table.save
      redirect_to restaurant_path(@restaurant)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @table = Table.new
  end

  def update
    @table.update(table_params)
    # redirect_to table_path(@table)
  end

  def destroy
    @table.destroy
    # redirect_to tables_path, status: :see_other
  end

  private

  def set_table
    @table = Table.find(params[:id])
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def table_params
    params.require(:table).permit(:table_number, :qr_code)
  end
end
