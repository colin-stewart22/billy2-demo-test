class AddTableOrderToTableCustomer < ActiveRecord::Migration[7.0]
  def change
    add_reference :table_customers, :table_order, null: false, foreign_key: true
  end
end
