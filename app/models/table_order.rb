class TableOrder < ApplicationRecord
  belongs_to :table
  belongs_to :user
  has_many :table_customers
  has_many :order_items, through: :table_customers
  has_one :restaurant, through: :table
end
