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
    service = CartItemDestroyService.new(params[:id]).call

    if service.success?
      render_custom_data_success(service.result.to_h)
    else
      render_service_error("Failed to delete cart item", service.errors)
    end
  end

  private

  def create_params
    params.require(:data).permit(:book_id)
  end

  def render_record_not_found
    render json: { message: "Data not found" }, status: :not_found
  end
end
