# frozen_string_literal: true

class RefreshTokenService < BaseServiceObject
  def initialize(refresh_token)
    super()
    @refresh_token = refresh_token
  end

  def call
    begin
      # Decode refresh token
      decoded = JwtService.decode_token(@refresh_token, ENV["JWT_REFRESH_SECRET"])

      # Generate new access token
      access_token = JwtService.encode_access_token(decoded["id"], decoded["role"])
      self.result = { message: "Session refreshed", token: access_token }
    rescue JWT::ExpiredSignature
      self.errors = ["Session expired. Please login to continue"]
    rescue JWT::MissingRequiredClaim || JWT::InvalidSignature
      self.errors = ["Token invalid. Please login to continue"]
    rescue StandardError => e
      self.errors = [e.message]
    end

    self
  end
end
