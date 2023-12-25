class CreateMasterDataTables < ActiveRecord::Migration[7.1]
  def change
    create_table :authors, id: :uuid do |t|
      t.string :name, null: false
      t.timestamps
    end

    create_table :categories, id: :uuid do |t|
      t.string :name, null: false
      t.timestamps
    end

    create_table :genres, id: :uuid do |t|
      t.string :name, null: false
      t.timestamps
    end

    create_table :languages, id: :uuid do |t|
      t.string :name, null: false
      t.timestamps
    end

    add_reference :user_profiles, :language,foreign_key: true, type: :uuid, null: false
  end
end
