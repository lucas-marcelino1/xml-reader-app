require 'rails_helper'

RSpec.describe "Sign In", type: :request do
  let!(:user) { create(:user) }

  describe "GET users/sign_in" do
    it "deve retornar sucesso" do
      get new_user_session_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST users/sign_in" do
    context 'com os parâmetros corretos' do
      it "deve retornar sucesso" do
        post new_user_session_path, params: {
          user: {
            email: user.email,
            password: user.password
          }
        }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'com os parâmetros incorretos' do
      it "deve retornar 422" do
        post new_user_session_path, params: {
          user: {
            email: user.email,
            password: 'abcde'
          }
        }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end