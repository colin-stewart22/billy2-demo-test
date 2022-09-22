class OrderItem < ApplicationRecord
  belongs_to :menu_item
  belongs_to :table_customer
  has_one :table_order, through: :table_customer
  has_one :table, through: :table_order
  has_one :restaurant, through: :table
  has_one :user, through: :table_order

  validates :estimated_serving_time, presence: true
end
