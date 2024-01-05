# frozen_string_literal: true

class Api::CartController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found

  def index
    service = CartIndexService.new(@user_id).call
    if service.success?
      render_custom_data_success(service.result.to_h)
    else
      render_service_error("Failed to fetch cart items", service.errors)
    end
  end

  def checkout
    cart = Cart.where(status: "PENDING").select("carts.id").find_by(user_id: @user_id)
    subtotal = CartItem.where(cart_id: cart.id).sum(:price)
    render json: { subtotal: subtotal }, status: :ok
  end

  private

  def checkout_params
    params.require(:data).permit(:cart_id)
  end

  def render_record_not_found
    render json: { message: "Cart not found" }, status: :not_found
  end
end
