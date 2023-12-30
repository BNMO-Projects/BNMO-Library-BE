# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Generate 10 author
(1..10).each do
  Author.create!(name: Faker::Book.author)
end

categories = ["Novel", "Manga", "Magazine", "Comic Book", "Text Book", "Graphic Novel", "Light Novel"]
# Generate 10 categories
categories.each do |category|
  Category.create!(name: category)
end

# Generate 10 genres
(1..7).each do
  Genre.create!(name: Faker::Book.genre)
end

languages = ["Bahasa Indonesia", "English (United States)", "English (United Kingdom)", "Japanese", "Spanish", "Korean", "Portuguese", "French", "German", "Mandarin"]
# Generate 7 languages
languages.each do |language|
  Language.create!(name: language)
end

# Generate 100 books
types = %w[BORROWABLE ONSALE]
(1..100).each do
  book_type = types.sample
  original_stock = Faker::Number.within(range: 1..100)
  Book.create!(
    title: Faker::Book.title,
    publication_year: Faker::Date.between(from: 2.years.ago.to_date, to: Date.today),
    isbn: Faker::IDNumber.valid,
    book_cover: "https://firebasestorage.googleapis.com/v0/b/bnmo-projects.appspot.com/o/book-cover%2F63b75e49-bb87-4499-82e8-e4b05d924201-Atomic%20Habit.jpg?alt=media&token=01eac1f5-4dcb-4df5-a882-ca23988ada0c",
    cover_file_name: "book-cover/63b75e49-bb87-4499-82e8-e4b05d924201-Atomic Habit.jpg",
    original_stock: original_stock,
    current_stock: Faker::Number.within(range: 1..original_stock),
    book_type: book_type,
    price: Faker::Number.within(range: 10000..500000),
    author_id: Author.pluck(:id).sample,
    category_id: Category.pluck(:id).sample,
    genre_id: Genre.pluck(:id).sample,
    language_id: Language.pluck(:id).sample)
end