class ChangeTableOrdersIsActive < ActiveRecord::Migration[7.0]
  def change
    change_column_default :table_orders, :is_active, false
  end
end
