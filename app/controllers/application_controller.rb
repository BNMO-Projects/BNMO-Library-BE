require 'jwt'

class ApplicationController < ActionController::API
  before_action :authenticate_user
  rescue_from StandardError, with: :render_standard_error
  rescue_from ActionController::UnpermittedParameters, with: :render_invalid_parameters

  private

  def authenticate_user
    bearer_token = request.headers["Authorization"]

    if bearer_token.blank?
      return render json: { message: "Authorization token is required" }, status: :unauthorized
    end
    token = bearer_token.split(" ")[1]

    begin
      decoded = JWT.decode(token, ENV["JWT_ACCESS_SECRET"], true, { required_claims: %w[id role exp], verify_expiration: true, algorithm: "HS256" })[0]
      @role = decoded["role"]
      @user_id = decoded["id"]
    rescue JWT::ExpiredSignature
      return render json: { message: "Session expired. Please login to continue" }, status: :unauthorized
    rescue JWT::MissingRequiredClaim || JWT::InvalidSignature
      return render json: { message: "Token invalid. Please login to continue" }, status: :unauthorized
    rescue StandardError => e
      return render_standard_error(e)
    end
  end

  def authenticate_admin
    unless @role == "ADMIN"
      render json: { message: "Access denied" }, status: :forbidden
    end
  end

  def render_valid_create(item)
    render json: { message: "#{item} created successfully" }, status: :created
  end

  def render_valid_update(item)
    render json: { message: "#{item} updated successfully" }, status: :ok
  end

  def render_valid_delete(item)
    render json: { message: "#{item} deleted successfully" }, status: :ok
  end

  def render_invalid_parameters(exception)
    # Triggers when an unexpected parameters presents in the request body

    error = exception.message.scan(/:(\w+)/)
    invalid_parameters = error.flatten
    message = "Found #{invalid_parameters.length} invalid parameters: [#{invalid_parameters.join(", ")}]"
    render json: { message: "Invalid parameters", error: message }, status: :unprocessable_entity
  end

  def render_standard_error(exception)
    render json: { message: "Internal server error", error: exception.message }, status: :internal_server_error
  end
end
