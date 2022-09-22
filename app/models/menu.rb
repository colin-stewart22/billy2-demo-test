class Menu < ApplicationRecord
  belongs_to :restaurant
  has_many :join_menus, dependent: :destroy
  has_many :menu_items, through: :join_menus
  has_one_attached :photo

  validates :name, presence: true
end
