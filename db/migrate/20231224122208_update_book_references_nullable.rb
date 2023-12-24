class UpdateBookReferencesNullable < ActiveRecord::Migration[7.1]
  def change
    remove_reference :book, :author
    remove_reference :book, :category
    remove_reference :book, :genre
    remove_reference :book, :language

    add_reference :book, :author, foreign_key: true, type: :uuid, null: false
    add_reference :book, :category, foreign_key: true, type: :uuid, null: false
    add_reference :book, :genre, foreign_key: true, type: :uuid, null: false
    add_reference :book, :language, foreign_key: true, type: :uuid, null: false
  end
end
