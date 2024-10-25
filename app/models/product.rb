class Product < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :name, :description, :price, :image, :category, presence: true
end
