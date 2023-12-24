class ApplicationController < ActionController::API
  rescue_from StandardError, with: :render_standard_error
  rescue_from ActionController::UnpermittedParameters, with: :render_invalid_parameters
  private

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
