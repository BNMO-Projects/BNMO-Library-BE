class CreateUserProfileTable < ActiveRecord::Migration[7.1]
  def change
    create_table :user_profiles, id: :uuid do |t|
      t.string :first_name, null: false
      t.string :last_name
      t.string :phone_number
      t.string :gender
      t.date :date_of_birth
      t.belongs_to :users, foreign_key: true, index: true, type: :uuid
      t.timestamps
    end

    add_index :user_profiles, :phone_number, unique: true
    add_reference :user_profiles, :user, foreign_key: true, type: :uuid, null: false, index: { unique: true }
  end
end
