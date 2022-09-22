class RemoveCreatedTimeFromOrderItems < ActiveRecord::Migration[7.0]
  def change
    remove_column :order_items, :created_time
  end
end
