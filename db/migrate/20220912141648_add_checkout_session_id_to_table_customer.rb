class AddCheckoutSessionIdToTableCustomer < ActiveRecord::Migration[7.0]
  def change
    add_column :table_customers, :checkout_session_id, :string
  end
end
