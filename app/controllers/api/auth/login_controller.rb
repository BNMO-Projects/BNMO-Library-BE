require 'jwt'

class Api::Auth::LoginController < ApplicationController
  def create
    begin
      # Find user based on username
      # Encode JWT token once found
      user = User.find_by(username: login_params[:username])

      if user && user.authenticate(login_params[:password])
        payload = { id: user.id, role: user.role }
        token = JWT.encode(payload, ENV["JWT_SECRET_KEY"] || "SECRET", "HS256")
        render json: { message: "Login successful", token: token }, status: :ok
      else
        render json: { message: "Invalid credentials" }, status: :unauthorized
      end

    rescue ActionController::UnpermittedParameters => e
      # See login_params for allowed parameters
      render_invalid_parameters(e)

    rescue StandardError => e
      render json: { message: "Internal server error", error: e.message }, status: :internal_server_error
    end
  end

  private

  def login_params
    # Allowed parameters are:
    # username, password
    params.require(:login).permit(:username, :password)
  end
end
