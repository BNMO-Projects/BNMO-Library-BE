require 'jwt'

class ApplicationController < ActionController::API
  before_action :authenticate_user
  rescue_from StandardError, with: :render_standard_error
  rescue_from ActionController::UnpermittedParameters, with: :render_invalid_parameters

  private

  def authenticate_user
    bearer_token = request.headers["Authorization"]
    return render json: { message: "Authorization token is required" }, status: :unauthorized if bearer_token.blank?
    service = AuthMiddlewareService.new(bearer_token.split(" ")[1]).call

    if service.success?
      @role = service.result.to_h[:role]
      @user_id = service.result.to_h[:user_id]
    else
      render_service_error("Failed to authenticate user", service.errors, status: :unauthorized)
    end
  end

  def authenticate_admin
    unless @role == "ADMIN"
      render_message("Access denied", status: :forbidden)
    end
  end

  def render_message(message, status: :ok)
    render json: { message: message }, status: status
  end

  def render_data_success(data, status: :ok)
    render json: { data: data }, status: status
  end

  def render_custom_data_success(custom_object, status: :ok)
    render json: custom_object, status: status
  end

  def render_service_error(message, errors, status: :unprocessable_entity)
    render json: { message: message, errors: errors }, status: status
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
