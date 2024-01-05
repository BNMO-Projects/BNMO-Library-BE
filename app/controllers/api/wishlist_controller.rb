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
    service = WishlistCreateService.new(@user_id, create_params[:book_id]).call

    if service.success?
      render_message("Book added to wishlist", status: :created)
    else
      render_service_error("Failed to add book to wishlist", service.errors)
    end
  end
  def destroy
    service = WishlistDestroyService.new(params[:id]).call

    if service.success?
      render_custom_data_success(service.result.to_h)
    else
      render_service_error("Failed to remove book from wishlist", service.errors)
    end
  end

  private

  def query_params
    params.permit(:currentPage, :limitPerPage, :bookType, :searchQuery)
  end

  def create_params
    params.require(:data).permit(:book_id)
  end

  def render_record_not_found
    render json: { message: "Wishlist not found" }, status: :not_found
  end
end
