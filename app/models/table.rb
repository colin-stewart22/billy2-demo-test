class Table < ApplicationRecord
  belongs_to :restaurant

  has_many :table_orders
  has_many :table_customers, through: :table_orders
  has_many :order_items, through: :table_customers

  validates :table_number, uniqueness: { scope: :restaurant }
end
