# frozen_string_literal: true

class Api::Auth::RefreshTokenController < ApplicationController
  skip_before_action :authenticate_user
  def create
    service = RefreshTokenService.new(create_params[:refresh_token]).call

    if service.success?
      render_custom_data_success(service.result.to_h)
    else
      render_service_error("Failed to refresh token", service.errors, status: :unauthorized)
    end
  end

  private

  def create_params
    params.permit(:refresh_token)
  end
end
