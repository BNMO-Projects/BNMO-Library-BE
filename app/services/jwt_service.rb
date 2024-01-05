# frozen_string_literal: true

class JwtService
  def self.encode_access_token(id, role)
    payload = { id: id, role: role, exp: Time.now.to_i + 300, token_type: "ACCESS" }
    JWT.encode(payload, ENV["JWT_ACCESS_SECRET"], "HS256", { typ: "JWT" })
  end

  def self.encode_refresh_token(id, role)
    payload = { id: id, role: role, exp: Time.now.to_i + 300, token_type: "REFRESH" }
    JWT.encode(payload, ENV["JWT_REFRESH_SECRET"], "HS256", { typ: "JWT" })
  end

  def self.decode_token(token, secret_key)
    JWT.decode(token, secret_key, true, { required_claims: %w[id role exp token_type], verify_expiration: true, algorithm: "HS256" })[0]
  end
end
