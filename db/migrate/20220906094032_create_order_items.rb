class CreateOrderItems < ActiveRecord::Migration[7.0]
  def change
    create_table :order_items do |t|
      t.time :created_time
      t.integer :estimated_serving_time
      t.boolean :is_served
      t.references :menu_item, null: false, foreign_key: true
      t.references :table_customer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
