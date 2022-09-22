class CreateJoinMenus < ActiveRecord::Migration[7.0]
  def change
    create_table :join_menus do |t|
      t.references :menu, null: false, foreign_key: true
      t.references :menu_item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
