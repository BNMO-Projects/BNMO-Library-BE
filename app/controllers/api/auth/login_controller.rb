# frozen_string_literal: true
require 'jwt'

class Api::Auth::LoginController < ApplicationController
  skip_before_action :authenticate_user

  def create
    service = UserLoginService.new(login_params).call

    if service.success?
      render_custom_data_success(service.result.to_h)
    else
      render_service_error("Failed to login", service.errors, status: :unauthorized)
    end
  end

  private

  def login_params
    # Allowed parameters are:
    # username, password
    params.require(:data).permit(:username, :password)
  end
end
