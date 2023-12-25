# frozen_string_literal: true
require 'jwt'

class Api::Auth::LoginController < ApplicationController
  def create
    # Find user based on username
    # Encode JWT token once found
    user = User.find_by(username: login_params[:username])

    if user && user.authenticate(login_params[:password])
      payload = { id: user.id, role: user.role }
      token = JWT.encode(payload, ENV["JWT_SECRET_KEY"] || "SECRET", "HS256")
      render json: { message: "Login successful", token: token }, status: :ok
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
