class ChangeTableCustomersBooleans < ActiveRecord::Migration[7.0]
  def change
    change_column_default :table_customers, :is_captain, false
    change_column_default :table_customers, :is_paid, false
  end
end
