# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2023_12_24_053100) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "book", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.date "publication_year", null: false
    t.string "isbn", null: false
    t.string "book_cover", null: false
    t.string "cover_file_name", null: false
    t.integer "original_stock", default: 0, null: false
    t.integer "current_stock", default: 0, null: false
    t.text "description"
    t.string "book_type", null: false
    t.uuid "author_id"
    t.uuid "category_id"
    t.uuid "genre_id"
    t.uuid "language_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "price"
  end

  create_table "book_author", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "lower((name)::text)", name: "index_author_name_unique_lowercase", unique: true
  end

  create_table "book_category", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "lower((name)::text)", name: "index_category_name_unique_lowercase", unique: true
  end

  create_table "book_genre", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "lower((name)::text)", name: "index_genre_name_unique_lowercase", unique: true
  end

  create_table "borrowed_book", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "borrow_date", null: false
    t.datetime "picked_up_date"
    t.datetime "deadline"
    t.datetime "return_date"
    t.string "status", default: "VALIDATING", null: false
    t.uuid "book_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_borrowed_book_on_book_id", unique: true
  end

  create_table "language", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "lower((name)::text)", name: "index_language_name_unique_lowercase", unique: true
  end

  create_table "sold_book", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "purchase_date", null: false
    t.integer "price", null: false
    t.uuid "book_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_sold_book_on_book_id", unique: true
  end

  create_table "user", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", null: false
    t.string "username", null: false
    t.string "password_digest", null: false
    t.string "role", default: "CUSTOMER", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email", "username"], name: "index_user_on_email_and_username", unique: true
  end

  create_table "user_address", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "street"
    t.string "city"
    t.string "state"
    t.string "postal_code"
    t.string "country"
    t.uuid "profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_user_address_on_profile_id", unique: true
  end

  create_table "user_profile", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name"
    t.string "phone_number"
    t.string "gender"
    t.date "date_of_birth"
    t.uuid "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "preferred_language_id"
    t.index ["phone_number", "user_id"], name: "index_user_profile_on_phone_number_and_user_id", unique: true
  end

  add_foreign_key "book", "book_author", column: "author_id"
  add_foreign_key "book", "book_category", column: "category_id"
  add_foreign_key "book", "book_genre", column: "genre_id"
  add_foreign_key "book", "language"
  add_foreign_key "borrowed_book", "book"
  add_foreign_key "sold_book", "book"
  add_foreign_key "user_address", "user_profile", column: "profile_id"
  add_foreign_key "user_profile", "language", column: "preferred_language_id"
  add_foreign_key "user_profile", "user"
end
