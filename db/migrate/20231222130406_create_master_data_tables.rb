class CreateMasterDataTables < ActiveRecord::Migration[7.1]
  def change
    create_table :book_author, id: :uuid do |t|
      t.string :name, null: false
      t.timestamps
    end

    create_table :book_category, id: :uuid do |t|
      t.string :name, null: false
      t.timestamps
    end

    create_table :book_genre, id: :uuid do |t|
      t.string :name, null: false
      t.timestamps
    end

    create_table :language, id: :uuid do |t|
      t.string :name, null: false
      t.timestamps
    end

    add_column :user_profile, :preferred_language_id, :uuid
    add_foreign_key :user_profile, :language, column: :preferred_language_id
  end
end
