require 'rails_helper'

describe 'Usuário entra na aplicação' do
  let(:user) { create(:user, password: 'ABC1234')}

  before(:each) do
    visit(root_path)
  end

  context 'com os dados preenchidos corretamente' do
    it 'realiza o login com sucesso' do
      visit(root_path)
      click_on('Entrar')

      within 'form' do
        fill_in('E-mail', with: user.email)
        fill_in('Senha', with: user.password)
        click_on('Entrar')
      end

      expect(page).not_to have_button('Entrar')
      expect(page).to have_button('Finalizar sessão')
      expect(page).to have_content('Login efetuado com sucesso')
    end
  end

  context 'com os dados preenchidos incorretamente' do
    it 'não realiza o login' do
      visit(root_path)
      click_on('Entrar')

      within 'form' do
        fill_in('E-mail', with: 'user@email.com')
        fill_in('Senha', with: user.password)
        click_on('Entrar')
      end

      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_button('Entrar')
      expect(page).to have_content('E-mail ou senha inválidos.')
    end
  end
end