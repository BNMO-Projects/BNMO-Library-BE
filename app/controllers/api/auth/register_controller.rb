class Api::Auth::RegisterController < ApplicationController
  def create
    begin
      # Create user and profile based on the request body
      # Will throw an exception when create failed
      @user = User.create!(email: register_params[:email], username: register_params[:username], password: register_params[:password], password_confirmation: register_params[:password_confirmation])
      @profile = UserProfile.create!(first_name: register_params[:first_name], last_name: register_params[:last_name], user_id: @user.id)

      if @user.valid? && @profile.valid?
        render json: { message: "Register successful" }, status: :created
      else
        render json: { message: "Failed to register", error: @user.errors }, status: :unprocessable_entity
      end

    rescue ActionController::UnpermittedParameters => e
      # See register_params for allowed parameters
      render_invalid_parameters(e)

    rescue ActiveRecord::RecordInvalid => e
      # Triggers when request body validation fails
      # See models/user.rb and models/user_profile.rb for validation details
      error_object = {}
      error_list = e.message.split(":")[1].strip.split(",")

      # Iterates each error within the error list and re-format the message
      error_list.each do |string|
        stripped_string = string.strip
        case stripped_string
        when "Password confirmation doesn't match Password"
          error_object["password_confirmation"] = "Confirmation password doesn't match"
        when "Email Email already exists"
          error_object["email"] = "Email already exists"
        when "Username Username already exists"
          error_object["username"] = "Username already exists"
        when "Password is too short (minimum is 8 characters)"
          error_object["password"] = "Password is too short (minimum is 8 characters)"
        else
          break
        end
      end
      render json: { message: "Failed to register", error: error_object }, status: :unprocessable_entity

    rescue StandardError => e
      render json: { message: "Internal server error", error: e.message }, status: :internal_server_error
    end
  end

  private

  def register_params
    # Allowed parameters are:
    # first_name, last_name, email, username, password, password_confirmation
    params.require(:register).permit(:first_name, :last_name, :email, :username, :password, :password_confirmation)
  end
end
