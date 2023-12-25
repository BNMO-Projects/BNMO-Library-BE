# frozen_string_literal: true

class Api::Admin::MasterData::LanguagesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found

  def index
    if query_params.blank?
      languages = Language.select("id, name").all
    else
      languages = Language.select("id, name").where("LOWER(name) LIKE ?", "%" + Language.sanitize_sql_like(query_params[:name].downcase) + "%")
    end

    render json: { data: languages }, status: :ok
  end

  def show
    language = Language.select("id, name").find_by!(id: params[:id])
    render json: { data: language }, status: :ok
  end

  def create
    language = Language.create(create_update_params)

    if language.valid?
      render_valid_create("Language")
    else
      render json: { message: "Failed to create new language", error: language.errors }, status: :unprocessable_entity
    end
  end

  def update
    language = Language.find_by!(id: params[:id])
    language.update(create_update_params)
    render_valid_update("Language")
  end

  def destroy
    language = Language.find_by!(id: params[:id])
    language.destroy
    render_valid_delete("Language")
  end

  private

  def query_params
    params.permit(:name)
  end

  def create_update_params
    params.require(:data).permit(:name)
  end

  def render_record_not_found
    render json: { message: "Language not found" }, status: :not_found
  end
end
