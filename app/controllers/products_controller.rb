class ProductsController < ApplicationController
  # before_action :authenticate_user!, only: [ :index, :show, :new, :create, :edit, :update, :destroy ]
  before_action :authenticate_user!, only: [ :index, :create, :new ]
  def index
    @products = Product.all.order("created_at DESC")
  end

  def new
    @product = Product.new
  end

  def create
    @product = current_user.products.build(product_params)
    if @product.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :price, :image, :category, :sold)
  end
end
