# frozen_string_literal: true

class Api::Admin::MasterData::GenresController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found

  def index
    if query_params.blank?
      genres = Genre.all
    else
      genres = Genre.where("LOWER(name) LIKE ?", "%" + Genre.sanitize_sql_like(query_params[:name].downcase) + "%")
    end

    render json: { data: genres }, status: :ok
  end

  def show
    genre = Genre.find_by!(id: params[:id])
    render json: { data: genre }, status: :ok
  end

  def create
    genre = Genre.create(create_params)

    if genre.valid?
      render_valid_json("Genre created successfully", :created)
    else
      render json: { message: "Failed to create genre", error: genre.errors }, status: :unprocessable_entity
    end
  end

  def update
    genre = Genre.find_by!(id: params[:id])
    genre.update(update_params)
    render_valid_json("Genre updated successfully", :ok)
  end

  def destroy
    genre = Genre.find_by!(id: params[:id])
    genre.destroy
    render_valid_json("Genre deleted successfully", :ok)
  end

  private

  def query_params
    params.permit(:name)
  end

  def create_params
    params.require(:data).permit(:name)
  end

  def update_params
    params.require(:data).permit(:name)
  end

  def render_record_not_found
    render json: { message: "Genre not found" }, status: :not_found
  end
end
