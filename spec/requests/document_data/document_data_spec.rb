require 'rails_helper'

RSpec.describe "DocumentData", type: :request do
  let!(:user) { create(:user) }

  before(:each) do
    login_as(user)
  end

  describe "GET DocumentData" do
    it "deve retornar sucesso" do
      get document_data_path

      expect(response).to have_http_status(:success)
    end
  end
end