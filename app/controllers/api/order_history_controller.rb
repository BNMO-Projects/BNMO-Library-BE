# frozen_string_literal: true

class Api::OrderHistoryController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found

  def index
    service = OrderHistoryIndexService.new(@user_id).call

    if service.success?
      render_custom_data_success(service.result.to_h)
    else
      render_service_error("Failed to fetch order history", service.errors)
    end
  end

  private

  def render_record_not_found
    render json: { message: "Order history not found" }, status: :not_found
  end
end
