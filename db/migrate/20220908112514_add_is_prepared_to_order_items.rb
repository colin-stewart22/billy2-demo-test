class AddIsPreparedToOrderItems < ActiveRecord::Migration[7.0]
  def change
    add_column :order_items, :is_prepared, :boolean, default: false
  end
end
