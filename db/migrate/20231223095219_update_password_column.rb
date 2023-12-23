class UpdatePasswordColumn < ActiveRecord::Migration[7.1]
  def change
    rename_column :user, :password, :password_digest
  end
end
