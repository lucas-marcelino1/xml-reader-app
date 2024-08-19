require 'rails_helper'

RSpec.describe ProcessXmlJob, type: :job do
  let!(:document) { create(:document) }

  describe '#perform' do
    context 'quando o documento existe' do
      it 'processa o XML, cria os dados e atualiza o status do documento' do
        expect { described_class.new.perform(document.id) }
          .to change { document.reload.status }.from('processing').to('completed')

        expect(DocumentDatum.count).to eq(3)
        expect(document.document_data.ids).to eq(DocumentDatum.ids)
      end
    end

    context 'quando o documento não existe' do
      it 'não processa o XML' do
        expect { described_class.new.perform(nil) }
          .not_to change { DocumentDatum.count }
      end
    end

    context 'quando um erro ocorre durante o processo' do
      before do
        allow(ExtractXmlData).to receive(:new).and_raise(StandardError.new('Parsing error'))
      end

      it 'atualiza o status do documento para failed e lança o erro' do
        expect { described_class.new.perform(document.id) }
          .to raise_error(StandardError, 'Parsing error')
                .and change { document.reload.status }.from('processing').to('failed')
        expect(DocumentDatum.count).to eq(0)
      end
    end
  end
end