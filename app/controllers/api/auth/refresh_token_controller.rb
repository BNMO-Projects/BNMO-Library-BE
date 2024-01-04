# frozen_string_literal: true
require 'jwt'

class Api::Auth::RefreshTokenController < ApplicationController
  skip_before_action :authenticate_user
  def create
    begin
      # Decode refresh token
      decoded = JWT.decode(create_params[:refresh_token], ENV["JWT_REFRESH_SECRET"], true, { required_claims: %w[id role exp], verify_expiration: true, algorithm: "HS256" })[0]

      # Build access token payload based on refresh token data
      access_token_payload = { id: decoded["id"], role: decoded["role"], exp: Time.now.to_i + 300, token_type: "ACCESS" }

      # Generate new access token
      access_token = JWT.encode(access_token_payload, ENV["JWT_ACCESS_SECRET"], "HS256", { typ: "JWT" })
      render json: { message: "Access refreshed", token: access_token }, status: :ok
    rescue JWT::ExpiredSignature
      return render json: { message: "Session expired. Please login to continue" }, status: :unauthorized
    rescue JWT::MissingRequiredClaim || JWT::InvalidSignature
      return render json: { message: "Token invalid. Please login to continue" }, status: :unauthorized
    rescue StandardError => e
      return render_standard_error(e)
    end
  end

  private

  def create_params
    params.permit(:refresh_token)
  end
end
