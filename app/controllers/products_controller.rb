class ProductsController < ApplicationController
  # before_action :authenticate_user!, only: [ :index, :create, :new, :show, :destroy ]
  before_action :authenticate_user!, except: [ :index, :show ]
  def index
    @products = Product.all.order("created_at DESC")
    @latest_products = Product.order("created_at DESC").limit(5)
  end

  def new
    @product = Product.new
  end

  def create
    @product = current_user.products.build(product_params)
    if @product.save
      redirect_to root_path, notice: "New product was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    id = params[:id]
    @product = Product.find_by(id: id)
  end

  def destroy
    @product = Product.find(params[:id])

    if @product.user == current_user
      @product.destroy
      respond_to do |format|
        format.html { redirect_to products_path, notice: "Product was successfully deleted." }
        format.turbo_stream { flash.now[:notice] = "Product was successfully deleted." }
      end
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :price, :image, :category, :sold)
  end
end
