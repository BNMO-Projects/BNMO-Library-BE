# frozen_string_literal: true
#
class Api::Auth::RegisterController < ApplicationController
  skip_before_action :authenticate_user

  def create
    # Create user and profile based on the request body
    # Will throw an exception when create failed
    @user = User.new(email: register_params[:email], username: register_params[:username], password: register_params[:password], password_confirmation: register_params[:password_confirmation])
    if @user.valid?
      profile = @user.build_user_profile(first_name: register_params[:first_name], last_name: register_params[:last_name])

      if profile.save
        render json: { message: "Register successful" }, status: :created
      else
        render json: { message: "Failed to register", error: profile.errors }, status: :unprocessable_entity
      end

    else
      render json: { message: "Failed to register", error: @user.errors }, status: :unprocessable_entity
    end

  end

  private

  def register_params
    # Allowed parameters are:
    # first_name, last_name, email, username, password, password_confirmation
    params.require(:data).permit(:first_name, :last_name, :email, :username, :password, :password_confirmation)
  end
end
