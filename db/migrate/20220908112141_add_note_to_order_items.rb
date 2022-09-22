class AddNoteToOrderItems < ActiveRecord::Migration[7.0]
  def change
    add_column :order_items, :note, :string
  end
end
