require 'rails_helper'

describe 'Usuário acessa a página de documentos' do
  let(:user) { create(:user) }
  let!(:document_1) { create(:document, name: 'Doc #1')}
  let!(:document_2) { create(:document, name: 'Doc #2')}
  let!(:document_3) { create(:document, name: 'Doc #3')}

  before(:each) do
    login_as(user)
    visit(documents_path)
  end

  context 'acessa os documentos da aplicação' do
    it 'visualiza os dados dos documentos' do
      expect(page).to have_content('Doc #1')
      expect(page).to have_content('Doc #2')
      expect(page).to have_content('Doc #3')
    end
  end

  context 'realiza ações nos documentos da aplicação' do
    it 'visualiza os dados do XML na página de relatório' do
      click_on('Visualizar', match: :first)

      expect(current_path).to eq(document_path(document_1))
      expect(page).to have_content('Relatório')
      expect(page).to have_content('XML em processamento, por favor recarregue a página.')
    end

    it 'deleta um documento com sucesso' do
      click_on('Deletar', match: :first)

      expect(current_path).to eq(documents_path)
      expect(page).to have_content('O documento foi excluído com sucesso!')
    end
  end

  context 'acessa a página de upload de XML' do
    it 'redirecionado para a página de cadastro de documento' do
      click_on('Upload de XML')

      expect(current_path).to eq(new_document_path)
      expect(page).to have_content('Faça upload de um documento XML')
    end

    context 'acessa o cadastro de documento' do
      it 'preenche corretamente e faz upload' do
        click_on('Upload de XML')

        within 'form' do
          fill_in('Nome', with: "Document Upload")
          attach_file("Arquivo", Rails.root + "spec/fixtures/files/example.xml")
          click_on('UPLOAD')
        end

        expect(page).to have_content('O documento foi criado com sucesso!')
      end

      it 'preenche incorretamente e retorna os erros' do
        click_on('Upload de XML')

        within 'form' do
          fill_in('Nome', with: "")
          click_on('UPLOAD')
        end

        expect(page).to have_content('Name não pode ficar em branco e upload não pode ficar em branco')
      end

      it 'clica em CANCELAR e retorna à home' do
        click_on('Upload de XML')

        within 'form' do
          click_on('CANCELAR')
        end

        expect(current_path).to eq(root_path)
      end
    end
  end
end