# frozen_string_literal: true

class DocumentDataController < ApplicationController
  before_action :authenticate_user!
  def index
    @search_term = params[:search]

    if @search_term.present?
      document_ids = DocumentDatum.where("data::text ILIKE ?", "%#{@search_term}%").pluck(:document_id)
      @document_data = DocumentDatum.where(document_id: document_ids)
    else
      @document_data = DocumentDatum.all
    end

    @document_data_grouped = @document_data.group_by(&:document_id)
  end
end

