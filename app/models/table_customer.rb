
class TableCustomer < ApplicationRecord
  has_many :order_items
  belongs_to :table_order
  has_one :table, through: :table_order
  has_one :restaurant, through: :table

  validates :name, presence: true
end
