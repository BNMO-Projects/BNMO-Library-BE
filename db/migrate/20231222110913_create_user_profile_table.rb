class CreateUserProfileTable < ActiveRecord::Migration[7.1]
  def change
    create_table :user_profile, id: :uuid do |t|
      t.string :firstName, null: false
      t.string :lastName
      t.string :phoneNumber
      t.string :gender
      t.date :dateOfBirth
      t.column :user_id, :uuid
      t.timestamps
    end

    add_foreign_key :user_profile, :user, column: :user_id
    add_index :user_profile, [:phoneNumber, :user_id], unique: true
  end
end
