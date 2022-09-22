class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :restaurants
  has_many :table_orders
  has_many :tables, through: :table_orders
  has_many :table_customers, through: :table_orders
  has_many :order_items, through: :table_customers
end
