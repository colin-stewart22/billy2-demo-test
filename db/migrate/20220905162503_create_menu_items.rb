class CreateMenuItems < ActiveRecord::Migration[7.0]
  def change
    create_table :menu_items do |t|
      t.string :name
      t.string :category
      t.string :description
      t.float :price
      t.integer :prepare_time

      t.timestamps
    end
  end
end
