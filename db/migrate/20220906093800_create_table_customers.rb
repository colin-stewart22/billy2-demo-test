class CreateTableCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :table_customers do |t|
      t.string :name
      t.boolean :is_captain
      t.boolean :is_paid
      t.float :amount_due
      t.float :tip_amount
      t.float :total_amount

      t.timestamps
    end
  end
end
