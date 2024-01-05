# frozen_string_literal: true

class Api::WishlistController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found

  def index
    service = WishlistIndexService.new(@user_id, query_params).call

    if service.success?
      render_custom_data_success(service.result.to_h)
    else
      render_service_error("Failed to fetch wishlist", service.errors)
    end
  end

  def create
    wishlist = Wishlist.create(book_id: create_params[:book_id], user_id: @user_id)

    if wishlist.valid?
      render_valid_create("Wishlist")
    else
      render json: { message: "Failed to create new wishlist", error: wishlist.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    wishlist = Wishlist.find_by!(id: params[:id])
    wishlist.destroy
    render_valid_delete("Wishlist")
  end

  private

  def query_params
    params.permit(:currentPage, :limitPerPage, :bookType, :searchQuery)
  end

  def create_params
    params.require(:data).permit(:book_id)
  end

  def required_params?(object)
    expected_keys = %w[currentPage limitPerPage bookType]

    return false unless object.is_a?(ActionController::Parameters)

    object.keys.sort == expected_keys.sort
  end

  def render_record_not_found
    render json: { message: "Wishlist not found" }, status: :not_found
  end
end
