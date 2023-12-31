# frozen_string_literal: true

class Api::CatalogMetadata::GenresController < ApplicationController
  def index
    if query_params[:name].present?
      @genre = Genre.where("LOWER(name) LIKE ?", "%" + Genre.sanitize_sql_like(query_params[:name].downcase) + "%").select("id, name").limit(5)
    else
      @genre = Genre.select("id, name").limit(5).all
    end

    render json: { data: @genre }, status: :ok
  end

  private

  def query_params
    params.permit(:name)
  end
end
