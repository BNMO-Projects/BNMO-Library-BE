# frozen_string_literal: true

class Api::Admin::BookManagementController < ApplicationController
  before_action :authenticate_admin
  rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found

  def index
    service = BookManagementIndexService.new(query_params).call

    if service.success?
      render_custom_data_success(service.result.to_h)
    else
      render_service_error("Failed to fetch book management list", service.errors)
    end
  end

  def show
    book = Book.find_by!(id: params[:id])
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
    book = Book.find_by!(id: params[:id])
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
