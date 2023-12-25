class CreateUserTable < ActiveRecord::Migration[7.1]
  def change
    create_table :users, id: :uuid do |t|
      t.string :email, null: false
      t.string :username, null: false
      t.string :password_digest, null: false
      t.string :role, null: false, default: 'CUSTOMER'
      t.timestamps
    end

    add_index :users, [:email, :username], unique: true
  end
end
