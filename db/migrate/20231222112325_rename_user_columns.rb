class RenameUserColumns < ActiveRecord::Migration[7.1]
  def change
    rename_column :user_profile, :firstName, :first_name
    rename_column :user_profile, :lastName, :last_name
    rename_column :user_profile, :phoneNumber, :phone_number
    rename_column :user_profile, :dateOfBirth, :date_of_birth
    rename_column :user_address, :postalCode, :postal_code
  end
end
