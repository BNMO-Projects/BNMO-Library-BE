# frozen_string_literal: true

class Api::CatalogController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found
  
  def index
    service = CatalogIndexService.new(query_params).call

    if service.success?
      render_custom_data_success(service.result.to_h)
    else
      render_service_error("Failed to fetch catalog list", service.errors)
    end
  end

  def show
    service = CatalogDetailService.new(params[:id]).call

    if service.success?
      render_data_success(service.result)
    else
      render_service_error("Failed to fetch catalog detail", service.errors)
    end
  end

  private

  def query_params
    params.permit(:currentPage, :limitPerPage, :bookType, :searchQuery, :authorQuery, :category, :genre, :language)
  end

  def render_record_not_found
    render json: { message: "Book not found" }, status: :not_found
  end
end
