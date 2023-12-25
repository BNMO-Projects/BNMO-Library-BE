class CreateSoldBookTable < ActiveRecord::Migration[7.1]
  def change
    create_table :sold_books, id: :uuid do |t|
      t.datetime :purchase_date, null: false
      t.integer :price, null: false
      t.timestamps
    end

    add_reference :sold_books, :book, foreign_key: true, type: :uuid, null: false, index: { unique: true }
  end
end
