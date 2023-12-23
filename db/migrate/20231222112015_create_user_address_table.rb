class CreateUserAddressTable < ActiveRecord::Migration[7.1]
  def change
    create_table :user_address, id: :uuid do |t|
      t.string :street
      t.string :city
      t.string :state
      t.string :postalCode
      t.string :country
      t.column :profile_id, :uuid
      t.timestamps
    end

    add_foreign_key :user_address, :user_profile, column: :profile_id
    add_index :user_address, :profile_id, unique: true
  end
end
