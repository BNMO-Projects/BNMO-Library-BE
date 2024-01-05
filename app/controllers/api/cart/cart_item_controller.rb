# frozen_string_literal: true

class Api::Cart::CartItemController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found

  def create
    service = CartItemCreateService.new(@user_id, create_params[:book_id]).call

    if service.success?
      render_message("Book added to cart", status: :created)
    else
      render_service_error("Failed to create cart item", service.errors)
    end
  end

  def destroy
    item = CartItem.find_by!(id: params[:id])
    item.destroy
    render_valid_delete("Cart item")
  end

  private

  def create_params
    params.require(:data).permit(:book_id)
  end

  def render_record_not_found
    render json: { message: "Cart item not found" }, status: :not_found
  end
end
