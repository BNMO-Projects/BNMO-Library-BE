# frozen_string_literal: true

class Api::CatalogMetadata::LanguagesController < ApplicationController
  def index
    if query_params[:name].present?
      @language = Language.where("LOWER(name) LIKE ?", "%" + Language.sanitize_sql_like(query_params[:name].downcase) + "%").select("id, name").limit(5)
    else
      @language = Language.select("id, name").limit(5).all
    end

    render json: { data: @language }, status: :ok
  end

  private

  def query_params
    params.permit(:name)
  end
end
