class Api::Admin::BookManagementController < ApplicationController
  def index
    @books = Book.all
    render json: { data: @books }, status: :ok
  end

  def show

  end

  def create
    book = Book.create(
      title: create_params[:title],
      publication_year: create_params[:publication_year],
      isbn: create_params[:isbn],
      book_cover: create_params[:book_cover],
      cover_file_name: create_params[:cover_file_name],
      original_stock: create_params[:original_stock],
      current_stock: create_params[:current_stock],
      description: create_params[:description],
      book_type: create_params[:book_type],
      price: create_params[:price],
      author_id: create_params[:author_id],
      category_id: create_params[:category_id],
      genre_id: create_params[:genre_id],
      language_id: create_params[:language_id])

    if book.valid?
      render json: { message: "Book added successfully" }, status: :created
    else
      render json: { message: "Failed to add new book", error: book.errors }, status: :unprocessable_entity
    end
  end

  def update

  end

  def destroy

  end

  private

  def create_params
    params.require(:data).permit(:title, :publication_year, :isbn, :book_cover, :cover_file_name, :original_stock, :current_stock, :description, :book_type, :price, :author_id, :category_id, :genre_id, :language_id)
  end
end
