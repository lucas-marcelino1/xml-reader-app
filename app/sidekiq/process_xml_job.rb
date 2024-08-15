class ProcessXmlJob
  include Sidekiq::Job

  def perform(document_id)
    document = Document.find(document_id)

    file_path = document.upload.path # Obtém o caminho do arquivo XML

    parsed_hash = parse_xml_to_hash(file_path)


    document.transaction do
      create_document_data(parsed_hash, document_id)
      document.update!(status: :completed)

      Turbo::StreamsChannel.broadcast_replace_to(
        "document_channel",  # Channel name
        target: "document_#{document_id}_status",  # Target element ID
        html: "<td id=document_#{document.id}_status>#{document.status.humanize}</td>"  # New content for the element
      )
    end
  end

  private

  def parse_xml_to_hash(file_path)
    require 'nokogiri'
    xml = File.open(file_path) { |f| Nokogiri::XML(f) }

    {
      invoice: extract_invoice_data(xml),
      product: extract_product_data(xml),
      totalizer: extract_totalizers_data(xml)
    }
  end

  def create_document_data(parsed_hash, document_id)
    parsed_hash.each_pair do |kind, data|
      DocumentDatum.create!(document_id:, kind:, data:)
    end
  end

  def extract_invoice_data(xml)
    {
      serie: xml.xpath('//xmlns:serie')&.text,
      nNF: xml.xpath('//xmlns:nNF')&.text,
      dhEmi: xml.xpath('//xmlns:dhEmi')&.text,
      emit: {
        CNPJ: xml.xpath('//xmlns:emit')&.at('CNPJ')&.text,
        xNome: xml.xpath('//xmlns:emit')&.at('xNome')&.text,
        xFant: xml.xpath('//xmlns:emit')&.at('xFant')&.text
        # TO-DO: ADICIONAR ENDEREÇO DO EMITENTE
      },
      dest: {
        CNPJ: xml.xpath('//xmlns:dest')&.at('CNPJ')&.text,
        xNome: xml.xpath('//xmlns:dest')&.at('xNome')&.text
        # TO-DO: ADICIONAR ENDEREÇO DO DESTINATÁRIO
      }
    }
  end

  def extract_product_data(xml)
    xml.xpath('//xmlns:det').map do |xml_det|
      {
        xProd: xml_det.at('prod').at('xProd')&.text,
        NCM: xml_det.at('prod').at('NCM')&.text,
        CFOP: xml_det.at('prod').at('CFOP')&.text,
        uCom: xml_det.at('prod').at('uCom')&.text,
        qCom: xml_det.at('prod').at('qCom')&.text,
        vUnCom: xml_det.at('prod').at('vUnCom')&.text,
        vICMS: xml_det.at('imposto').at('vICMS')&.text,
        vIPI: xml_det.at('imposto').at('vIPI')&.text,
        vPIS: xml_det.at('imposto').at('vPIS')&.text,
        vCOFINS: xml_det.at('imposto').at('vCOFINS')&.text
      }
    end
  end

  def extract_totalizers_data(xml)
    {
      vICMS: xml.xpath('//xmlns:total').at('vICMS')&.text,
      vProd: xml.xpath('//xmlns:total').at('vProd')&.text,
      vIPI: xml.xpath('//xmlns:total').at('vIPI')&.text,
      vPIS: xml.xpath('//xmlns:total').at('vPIS')&.text,
      vCOFINS: xml.xpath('//xmlns:total').at('vCOFINS')&.text,
      vNF: xml.xpath('//xmlns:total').at('vNF')&.text,
      vTotTrib: xml.xpath('//xmlns:total').at('vTotTrib')&.text
    }
  end
end
