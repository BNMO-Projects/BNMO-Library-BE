# frozen_string_literal: true

class Api::CartController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found

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
