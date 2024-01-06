# frozen_string_literal: true

class AuthMiddlewareService < BaseServiceObject
  def initialize(token)
    super()
    @token = token
  end

  def call
    begin
      decoded = JwtService.decode_token(@token, ENV["JWT_ACCESS_SECRET"])
      self.result = { role: decoded["role"], user_id: decoded["id"] }
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
