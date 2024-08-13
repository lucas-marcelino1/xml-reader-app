# frozen_string_literal: true

class DocumentsController < ApplicationController

  def new
    @document = Document.new
  end

  def create
    @document = Document.new(document_params)
    if @document.save
      redirect_to root_path, notice: "Document was successfully created!"
    else
      render :new
    end
  end

  private

  def document_params
    params.require(:document).permit(:name, :upload)
  end
end
