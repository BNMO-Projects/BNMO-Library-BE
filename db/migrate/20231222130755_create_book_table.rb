class CreateBookTable < ActiveRecord::Migration[7.1]
  def change
    create_table :books, id: :uuid do |t|
      t.string :title, null: false
      t.date :publication_year, null: false
      t.string :isbn, null: false
      t.string :book_cover, null: false
      t.string :cover_file_name, null: false
      t.integer :original_stock, null: false, default: 0
      t.integer :current_stock, null: false, default: 0
      t.text :description
      t.string :book_type, null: false
      t.integer :price
      t.timestamps
    end

    add_reference :books, :author, foreign_key: true, type: :uuid, null: false
    add_reference :books, :category, foreign_key: true, type: :uuid, null: false
    add_reference :books, :genre, foreign_key: true, type: :uuid, null: false
    add_reference :books, :language, foreign_key: true, type: :uuid, null: false
  end
end
