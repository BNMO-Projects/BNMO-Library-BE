# frozen_string_literal: true
#
class Api::Auth::RegisterController < ApplicationController
  skip_before_action :authenticate_user

  def create
    service = UserRegistrationService.new(user_params, profile_params).call

    if service.success?
      render_message("Register successful", status: :created)
    else
      render_service_error("Failed to register", service.errors)
    end
  end

  private
  # Allowed parameters are:
  # first_name, last_name, email, username, password, password_confirmation

  def register_params
    params.require(:data).permit(:first_name, :last_name, :email, :username, :password, :password_confirmation)
  end
  def user_params
    register_params.slice(:email, :username, :password, :password_confirmation)
  end

  def profile_params
    register_params.slice(:first_name, :last_name)
  end
end
