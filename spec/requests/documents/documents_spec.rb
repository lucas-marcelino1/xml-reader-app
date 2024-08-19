require 'rails_helper'

RSpec.describe "Documents", type: :request do
  let!(:user) { create(:user) }

  before(:each) do
    login_as(user)
  end

  describe "GET Documents" do
    it "deve retornar sucesso" do
      get documents_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET Document" do
    it "deve retornar sucesso" do
      document = create(:document)
      get documents_path(document)

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET new Document" do
    it "deve retornar sucesso" do
      get new_document_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "Post Document" do
    context 'com parâmetros corretos' do
      it "deve retornar sucesso" do
        post documents_path, params: {
          document: {
            name: "Reza a lenda",
            upload: Rack::Test::UploadedFile.new('spec/fixtures/files/example.xml')
          }
        }

        expect(response).to redirect_to(documents_path)
      end
    end

    context 'com parâmetros incorretos' do
      it "deve retornar 422" do
        post documents_path, params: {
          document: {
            name: nil,
            upload: nil
          }
        }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE document" do
    it "deve retornar sucesso" do
      document = create(:document)
      delete document_path(document)

      expect(response).to have_http_status(:redirect)
    end

    it "deve ser redirecionado por não existir o document" do
      delete documents_path("não existe")

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET download" do
    it "deve retornar sucesso" do
      document = create(:document)
      get download_document_path(document)

      expect(response).to have_http_status(:success)
    end
  end
end