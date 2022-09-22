class AddIsActiveToTable < ActiveRecord::Migration[7.0]
  def change
    add_column :tables, :is_active, :boolean, default: false
  end
end
