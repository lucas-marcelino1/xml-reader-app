# frozen_string_literal: true

class DocumentsController < ApplicationController
  before_action :set_document, only: %i[destroy download]
  before_action :authenticate_user!

  def index
    @documents = Document.all
  end

  def new
    @document = Document.new
  end

  def create
    @document = Document.new(document_params)
    if @document.save
      redirect_to documents_path, notice: "Document was successfully created!"
    else
      render :new
    end
  end

  def destroy
    if @document.destroy
      redirect_back_or_to root_path, notice: "Document was successfully deleted!"
    else
      render :index
    end
  end

  def download
    send_file @document.upload.path
  end

  private

  def document_params
    params.require(:document).permit(:name, :upload)
  end

  def set_document
    @document = Document.find(params[:id])
  end
end
