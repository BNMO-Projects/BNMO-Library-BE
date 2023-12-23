class CreateUserTable < ActiveRecord::Migration[7.1]
  def change
    create_table :user, id: :uuid do |t|
      t.string :email, null: false
      t.string :username, null: false
      t.string :password, null: false
      t.string :role, null: false, default: 'CUSTOMER'
      t.timestamps
    end

    add_index :user, [:email, :username], unique: true
  end
end
