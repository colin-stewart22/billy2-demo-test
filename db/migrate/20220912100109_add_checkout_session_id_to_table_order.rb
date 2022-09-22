class AddCheckoutSessionIdToTableOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :table_orders, :checkout_session_id, :string
  end
end
