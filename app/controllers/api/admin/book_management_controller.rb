# frozen_string_literal: true

class Api::Admin::BookManagementController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found

  def index
    page = query_params[:currentPage].to_i
    limit = query_params[:limitPerPage].to_i
    offset = (page - 1) * limit
    if required_params?(query_params)
      books = Book.limit(limit).offset(offset).select("id, title, isbn, book_cover, original_stock, current_stock, book_type")
    else
      books = Book
                .limit(limit)
                .offset(offset)
                .includes(:author, :category, :genre, :language)
                .where("LOWER(book.title) LIKE ?", "%" + Book.sanitize_sql_like(query_params[:searchQuery].downcase) + "%")
                .where("LOWER(authors.name) LIKE ?", "%" + Author.sanitize_sql_like(query_params[:authorQuery].downcase) + "%" if query_params[:searchQuery].present?)
                .select("id, title, isbn, book_cover, original_stock, current_stock, book_type")
    end

    render json: { data: books }, status: :ok
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
    params.permit(:currentPage, :limitPerPage, :bookType, :searchQuery, :authorQuery, :categoryId, :genreId, :languageId)
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
