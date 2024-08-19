require 'rails_helper'

describe 'Usuário se cadastra na aplicação' do
  before(:each) do
    visit(root_path)
  end

  context 'com dados preenchidos corretamente' do
    it 'cadastra o usuário e entra na aplicação' do
      click_on('Cadastrar')

      within 'form' do
        fill_in('E-mail', with: 'user@email.com')
        fill_in('Senha', with: 'ABC1234')
        fill_in('Confirme sua senha', with: 'ABC1234')
        click_on('Cadastrar')
      end

      expect(current_path).to eq(root_path)
      expect(page).to have_button('Finalizar sessão')
      expect(page).to have_content('Bem vindo! Você realizou seu registro com sucesso')
    end
  end

  context 'com dados preenchidos incorretamente' do
    it 'não cadastra o usuário' do
      click_on('Cadastrar')

      within 'form' do
        fill_in('E-mail', with: 'user@email.com')
        fill_in('Senha', with: 'ABC12345678')
        fill_in('Confirme sua senha', with: 'ABC1234')
        click_on('Cadastrar')
      end

      expect(page).to have_content('Não foi possível salvar usuário')
      expect(page).to have_button('Cadastrar')
    end
  end
end