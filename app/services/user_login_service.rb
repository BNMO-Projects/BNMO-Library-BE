# frozen_string_literal: true

class UserLoginService < BaseServiceObject
  def initialize(login_params)
    super()
    @login_params = login_params
  end

  def call
    user = User.find_by_username(@login_params[:username])

    if user && user.authenticate(@login_params[:password])
      access_token = JwtService.encode_access_token(user)
      refresh_token = JwtService.encode_refresh_token(user)
      self.result = { username: user.username, access_token: access_token, refresh_token: refresh_token }
    else
      self.errors = ["Invalid credentials"]
    end

    self
  end
end
