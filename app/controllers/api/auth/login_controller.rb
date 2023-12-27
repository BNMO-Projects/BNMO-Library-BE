# frozen_string_literal: true
require 'jwt'

class Api::Auth::LoginController < ApplicationController
  skip_before_action :authenticate_user

  def create
    # Find user based on username
    # Encode JWT token once found
    user = User.find_by(username: login_params[:username])

    if user && user.authenticate(login_params[:password])
      # Access token expiry: 5 minutes
      # Refresh token expiry: 7 days

      access_token_payload = { id: user.id, role: user.role, exp: Time.now.to_i + 300, token_type: "ACCESS" }
      refresh_token_payload = { id: user.id, role: user.role, exp: Time.now.to_i + (7 * 60 * 60 * 24), token_type: "REFRESH" }

      access_token = JWT.encode(access_token_payload, ENV["JWT_ACCESS_SECRET"], "HS256", { typ: "JWT" })
      refresh_token = JWT.encode(refresh_token_payload, ENV["JWT_REFRESH_SECRET"], "HS256", { typ: "JWT" })
      render json: { message: "Login successful", access_token: access_token, refresh_token: refresh_token }, status: :ok
    else
      render_invalid_credentials
    end
  end

  private

  def login_params
    # Allowed parameters are:
    # username, password
    params.require(:data).permit(:username, :password)
  end

  def render_invalid_credentials
    render json: { message: "Invalid credentials" }, status: :unauthorized
  end
end
