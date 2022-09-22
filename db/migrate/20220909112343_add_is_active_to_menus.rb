class AddIsActiveToMenus < ActiveRecord::Migration[7.0]
  def change
    add_column :menus, :is_active, :boolean, default: false
  end
end
