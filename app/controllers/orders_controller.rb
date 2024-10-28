class OrdersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_order, only: [ :show, :confirm, :cancel ]
    before_action :check_owner, only: [ :confirm, :cancel ]

    def index
        @orders_as_buyer = Order.where(user_id: current_user.id).where(status: [ "pending" ])
        @orders_as_owner = Order.joins(:product).where(products: { user_id: current_user.id }).where(status: [ "pending" ])
    end

    def show
        @confirmed_orders_as_buyer = current_user.orders_as_buyer.where(status: "confirmed")
        @canceled_orders_as_buyer = current_user.orders_as_buyer.where(status: "cancelled")

        @confirmed_orders_as_owner = current_user.orders_as_owner.where(status: "confirmed")
        @canceled_orders_as_owner = current_user.orders_as_owner.where(status: "cancelled")
    end

    def create
        @product = Product.find(params[:product_id])
        @order = current_user.orders.build(product: @product, status: "pending")

        if @order.save
            flash[:notice] = "Your order for #{@order.product.name} has been placed."
            respond_to do |format|
                format.turbo_stream { render turbo_stream: turbo_stream.replace("product_#{@product.id}_order", partial: "products/order_buttons", locals: { product: @product }) }
                format.html { redirect_to orders_path }
            end
        else
            flash.now[:alert] = "There was an issue placing your order."
            render :new
          # respond_to do |format|
          #     format.html { render :new }
          #     format.turbo_stream { render turbo_stream: turbo_stream.replace("order_form", partial: "form", locals: { order: @order }) }
          #   end
        end
    end

    def confirm
        unless @order
            flash[:alert] = "Order not found."
            redirect_to orders_path and return
        end

        if @order.update(status: "confirmed")
            flash[:notice] = "Order confirmed successfully."
            respond_to do |format|
                format.turbo_stream { render turbo_stream: turbo_stream.replace("product_#{@order.product.id}_order", partial: "products/order_buttons", locals: { product: @order.product }) }
                format.html { redirect_to orders_path, notice: "Order confirmed successfully." }
            end
            @order.product.update(sold: true)
        else
            flash[:alert] = "Failed to confirm the order."
            redirect_to orders_path
        end
    end

    # def cancel
    #     order = Order.find(params[:id])
    #     order.update(status: "canceled")
    #     redirect_to orders_path, alert: "Order canceled successfully."
    # end

    def cancel
      if @order.update(status: "canceled")
          flash.now[:notice] = "Order canceled successfully."
          respond_to do |format|
              format.turbo_stream { render turbo_stream: turbo_stream.replace("product_#{@order.product.id}_order", partial: "products/order_buttons", locals: { product: @order.product }) }
            format.html { redirect_to orders_path, notice: "Order canceled successfully!" }
          end
      else
          flash[:alert] = "Failed to cancel the order."
          redirect_to orders_path
      end
    end

    private

    def set_order
        @order = Order.find(params[:id])
    end

    def check_owner
        unless @order.product.user == current_user || @order.user == current_user
            redirect_to orders_path, alert: "You are not authorized to perform this action."
        end
    end
end
