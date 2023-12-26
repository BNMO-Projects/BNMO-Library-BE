# frozen_string_literal: true

class Api::Admin::BookManagementController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found

  def index
    page = query_params[:currentPage].to_i
    limit = query_params[:limitPerPage].to_i
    offset = (page - 1) * limit
    if required_params?(query_params)
      @books = Book.limit(limit).offset(offset).joins(:author).select("books.id, books.title, books.isbn, books.book_cover, books.original_stock, books.current_stock, books.book_type, authors.name AS author_name")
    else
      if query_params[:currentPage].present? && query_params[:limitPerPage].present?
        # Search queries with 5 possible options
        # Case-insensitive search for book title or author name
        # Equal search for category, genre, and language
        @books = Book.limit(limit).offset(offset).joins(:author, :category, :genre, :language).select("books.id, books.title, books.isbn, books.book_cover, books.original_stock, books.current_stock, books.book_type, authors.name AS author_name")
        @books = @books.where("LOWER(books.title) LIKE ?", "%" + Book.sanitize_sql_like(query_params[:searchQuery].downcase) + "%") unless query_params[:searchQuery].blank?
        @books = @books.where("LOWER(authors.name) LIKE ?", "%" + Author.sanitize_sql_like(query_params[:authorQuery].downcase) + "%") unless query_params[:authorQuery].blank?
        @books = @books.where("LOWER(categories.name) = ?", Category.sanitize_sql_like(query_params[:category].downcase)) unless query_params[:category].blank?
        @books = @books.where("LOWER(genres.name) = ?", Genre.sanitize_sql_like(query_params[:genre].downcase)) unless query_params[:genre].blank?
        @books = @books.where("LOWER(languages.name) = ?", Language.sanitize_sql_like(query_params[:language].downcase)) unless query_params[:language].blank?
      else
        return render json: { message: "Invalid parameters. currentPage or limitPerPage is missing" }, status: :unprocessable_entity
      end
    end

    render json: { data: @books }, status: :ok
  end

  def show
    book = Book.find_by(id: params[:id])
    book = preprocess_book_output(book)

    render json: { data: book }, status: :ok
  end

  def create
    book = Book.create(create_update_params)

    if book.valid?
      render_valid_create("Book")
    else
      render json: { message: "Failed to create new book", error: book.errors }, status: :unprocessable_entity
    end
  end

  def update
    book = Book.find_by(id: params[:id])
    book.update(create_update_params)

    if book.valid?
      render_valid_update("Book")
    else
      render json: { message: "Failed to update book", error: book.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    book = Book.find_by!(id: params[:id])
    book.destroy
    render_valid_delete("Book")
  end

  private

  def query_params
    params.permit(:currentPage, :limitPerPage, :bookType, :searchQuery, :authorQuery, :category, :genre, :language)
  end

  def create_update_params
    params.require(:data).permit(:title, :publication_year, :isbn, :book_cover, :cover_file_name, :original_stock, :current_stock, :description, :book_type, :price, :author_id, :category_id, :genre_id, :language_id)
  end

  def required_params?(object)
    expected_keys = %w[currentPage limitPerPage]

    return false unless object.is_a?(ActionController::Parameters)

    object.keys.sort == expected_keys.sort
  end

  def preprocess_book_output(item)
    book = item.attributes.except("author_id", "category_id", "genre_id", "language_id")
    book["author_name"] = item.author.name
    book["category_name"] = item.category.name
    book["genre_name"] = item.genre.name
    book["language_name"] = item.language.name

    book
  end

  def render_record_not_found
    render json: { message: "Book not found" }, status: :not_found
  end
end
