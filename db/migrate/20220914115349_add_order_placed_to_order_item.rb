class AddOrderPlacedToOrderItem < ActiveRecord::Migration[7.0]
  def change
    add_column :order_items, :is_ordered, :boolean, default: false
  end
end
