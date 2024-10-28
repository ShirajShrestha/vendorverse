class User < ApplicationRecord
  has_many :products, dependent: :destroy
  has_many :orders, dependent: :destroy

  # Method to get orders where the user is the buyer
  def orders_as_buyer
    orders.includes(:product).where(products: { user_id: id })
  end

  # Method to get orders where the user is the owner of the product
  def orders_as_owner
    Order.joins(:product).where(products: { user_id: id })
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

         has_one_attached :image
end
