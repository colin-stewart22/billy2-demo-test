class MenuItem < ApplicationRecord
  has_many :join_menus
  has_many :menus, through: :join_menus
  has_one_attached :photo
  belongs_to :restaurant

  validates :name, presence: true
  validates :name, uniqueness: { scope: :restaurant }

  validates :category, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :prepare_time, presence: true

  # Max characters for description is 100
  validates :description, length: { maximum: 1000 }
end
