require 'rails_helper'

RSpec.describe "Home", type: :request do
  describe "GET home" do
    it "deve retornar sucesso" do
      get root_path

      expect(response).to have_http_status(:success)
    end
  end
end