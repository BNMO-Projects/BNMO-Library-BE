class Api::Admin::BookManagementController < ApplicationController
  def index
    @books = Book.all
    render json: { data: @books }, status: :ok
  end

  def show

  end

  def create
    begin
      book = Book.create(
        title: create_book_params[:title],
        publication_year: create_book_params[:publication_year],
        isbn: create_book_params[:isbn],
        book_cover: create_book_params[:book_cover],
        cover_file_name: create_book_params[:cover_file_name],
        original_stock: create_book_params[:original_stock],
        current_stock: create_book_params[:current_stock],
        description: create_book_params[:description],
        book_type: create_book_params[:book_type],
        price: create_book_params[:price],
        author_id: create_book_params[:author_id],
        category_id: create_book_params[:category_id],
        genre_id: create_book_params[:genre_id],
        language_id: create_book_params[:language_id])

      if book.valid?
        render json: { message: "Book added successfully" }, status: :created
      else
        render json: { message: "Failed to add new book", error: book.errors }, status: :unprocessable_entity
      end

    rescue ActionController::UnpermittedParameters => e
      # See create_book_params for allowed parameters
      render_invalid_parameters(e)

    rescue StandardError => e
      render json: { message: "Internal server error", error: e.message }, status: :internal_server_error
    end
  end

  def update

  end

  def destroy

  end

  private

  def create_book_params
    params.require(:book_management).permit(:title, :publication_year, :isbn, :book_cover, :cover_file_name, :original_stock, :current_stock, :description, :book_type, :price, :author_id, :category_id, :genre_id, :language_id)
  end
end
