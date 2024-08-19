require 'rails_helper'

describe 'Usuário acessa a página de dados dos documentos' do
  let(:user) { create(:user) }
  let!(:document) { create(:document, name: 'Doc #1')}
  let!(:document_2) { create(:document, name: 'Doc #2')}

  before(:each) do
    login_as(user)
  end

  context 'existem dados dos documentos na aplicação' do
    let!(:invoice_data) { create(:document_datum, :invoice, document: document) }
    let!(:product_data) { create(:document_datum, :product, document: document) }
    let!(:totalizer_data) { create(:document_datum, :totalizer, document: document) }

    before(:each) do
      visit(document_data_path)
    end

    it 'visualiza os dados das faturas' do
      within('.invoice-section') do
        expect(page).to have_content(invoice_data.data["nNF"])
        expect(page).to have_content(invoice_data.data["serie"])
        expect(page).to have_content(invoice_data.data["dhEmi"])
        expect(page).to have_content(invoice_data.data["emit"]["CNPJ"])
        expect(page).to have_content(invoice_data.data["emit"]["xNome"])
        expect(page).to have_content(invoice_data.data["dest"]["CNPJ"])
        expect(page).to have_content(invoice_data.data["dest"]["xNome"])
      end

      within('.product-section') do
        product_data.data.each do |product|
          expect(page).to have_content(product["NCM"])
          expect(page).to have_content(product["CFOP"])
          expect(page).to have_content(product["qCom"])
          expect(page).to have_content(product["uCom"])
          expect(page).to have_content(product["vIPI"])
          expect(page).to have_content(product["vICMS"])
          expect(page).to have_content(product["xProd"])
          expect(page).to have_content(product["vUnCom"])
        end
      end

      within('.totalizer-section') do
        expect(page).to have_content(totalizer_data.data["vNF"])
        expect(page).to have_content(totalizer_data.data["vIPI"])
        expect(page).to have_content(totalizer_data.data["vICMS"])
        expect(page).to have_content(totalizer_data.data["vProd"])
        expect(page).to have_content(totalizer_data.data["vTotTrib"])
      end
    end

    context 'realiza uma busca pelo campo de pesquisa' do
      let!(:invoice_data_2) { create(:document_datum, :invoice_2, document: document_2) }
      let!(:product_data_2) { create(:document_datum, :product, document: document_2) }
      let!(:totalizer_data_2) { create(:document_datum, :totalizer, document: document_2) }

      it 'encontra todos os dados pesquisados' do
        within 'form' do
          fill_in('Buscar:', with: "777778")
          click_on('Buscar')
        end

        expect(page).to have_content("A1 CLIENTE")
        expect(page).to have_content("XXXAAA CLIENTE")
      end

      it 'não encontra os dados pesquisados' do
        within 'form' do
          fill_in('Buscar:', with: "7777789999999999999999")
          click_on('Buscar')
        end

        expect(page).to have_content('Nenhum registro encontrado.')
      end

      it 'os dados pesquisados são únicos' do
        within 'form' do
          fill_in('Buscar:', with: "A1")
          click_on('Buscar')
        end

        expect(page).to have_content("A1 CLIENTE")
        expect(page).not_to have_content("XXXAAA CLIENTE")
      end
    end
  end

  context 'não existem dados dos documentos na aplicação' do
    before(:each) do
      visit(document_data_path(document))
    end
    it 'visualiza mensagem para realizar uploads' do
      expect(page).to have_content('Nenhum registro disponível. Por favor, faça o upload de arquivos para visualizar as informações.')
    end
  end
end