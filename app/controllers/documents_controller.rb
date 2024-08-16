# frozen_string_literal: true

class DocumentsController < ApplicationController
  before_action :set_document, only: %i[destroy download show]
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
      redirect_to documents_path, notice: "O documento foi criado com sucesso!"
    else
      render :new
    end
  end

  def destroy
    if @document.destroy
      redirect_to documents_path, notice: "O documento foi excluído com sucesso!"
    else
      render :index
    end
  end

  def download
    send_file @document.upload.path
  end

  def show
    @document_data = @document.document_data
    @document_data_invoice = @document_data.invoice.first
    @document_data_product = @document_data.product.first
    @document_data_totalizer = @document_data.totalizer.first
  end

  private

  def document_params
    params.require(:document).permit(:name, :upload)
  end

  def set_document
    @document = Document.find(params[:id])
  end
end
