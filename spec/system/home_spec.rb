require 'rails_helper'

describe 'Usuário acessa a tela inicial' do
  let(:user) { create(:user) }

  context 'Usuário não está logado' do
    before(:each) do
      visit(root_path)
    end

    it 'visualiza os botões de entrar e cadastrar' do
      expect(page).to have_button("Cadastrar")
      expect(page).to have_button("Entrar")
    end

    it 'clica no botão de cadastrar e leva ao cadastro' do
      click_on('Cadastrar')

      expect(current_path).to eq(new_user_registration_path)
    end

    it 'clica no botão de entrar e leva ao login' do
      click_on('Entrar')

      expect(current_path).to eq(new_user_session_path)
    end
  end

  context 'Usuário está logado' do
    before(:each) do
      login_as(user)
      visit(root_path)
    end

    it 'visualiza os botões de ações' do
      expect(page).to have_button("Dados dos XML's")
      expect(page).to have_button("Documentos")
      expect(page).to have_button("Upload de XML")
      expect(page).to have_button("Finalizar sessão")
    end

    it "clica no botão dos Dados dos Xml's e leva à pagina" do
      click_on("Dados dos XML's")

      expect(current_path).to eq(document_data_path)
    end

    it 'clica no botão Documentos e leva à pagina' do
      click_on('Documentos')

      expect(current_path).to eq(documents_path)
    end

    it 'clica no botão Upload de XML e leva à pagina' do
      click_on('Upload de XML')

      expect(current_path).to eq(new_document_path)
    end

    it 'clica no botão Finalizar sessão e desloga' do
      click_on('Finalizar sessão')

      expect(page).not_to have_content('Finalizar sessão')
      expect(page).to have_button("Cadastrar")
      expect(page).to have_button("Entrar")
    end
  end
end