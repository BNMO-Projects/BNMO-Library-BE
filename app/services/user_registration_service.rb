# frozen_string_literal: true

class UserRegistrationService < BaseServiceObject
  def initialize(user_params, profile_params)
    super()
    @user_params = user_params
    @profile_params = profile_params
  end

  def call
    user = User.new(@user_params)

    if user.valid?
      profile = user.build_user_profile(@profile_params)

      if profile.valid?
        profile.save
        self.result = { user: user, profile: profile }
      else
        self.errors = profile.errors.full_messages
      end

    else
      self.errors = user.errors.full_messages
    end

    self
  end
end
