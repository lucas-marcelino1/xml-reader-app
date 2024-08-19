require 'rails_helper'

RSpec.describe "Sign Up", type: :request do
  describe "GET users/sign_up" do
    it "deve retornar sucesso" do
      get new_user_registration_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST users" do
    context 'com os parâmetros corretos' do
      it "deve retornar sucesso" do
        post '/users', params: {
          user: {
            email: 'user@email.com',
            password: 'ABCD1234',
            password_confirmation: 'ABCD1234'
          }
        }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'com os parâmetros incorretos' do
      it "deve retornar 422" do
        post '/users', params: {
          user: {
            email: 'user@email.com',
            password: 'ABCD1234',
            password_confirmation: 'ABCD'
          }
        }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end