class CreateUserAddressTable < ActiveRecord::Migration[7.1]
  def change
    create_table :user_addresses, id: :uuid do |t|
      t.string :street
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :country
      t.timestamps
    end

    add_reference :user_addresses, :user_profile, foreign_key: true, type: :uuid, null: false, index: { unique: true }
  end
end
