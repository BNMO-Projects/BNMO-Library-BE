class UserProfile < ApplicationRecord
  self.table_name = "user_profile"

  validates :first_name, presence: { message: "First name is required" }
end
