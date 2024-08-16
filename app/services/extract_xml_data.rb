# frozen_string_literal: true

class ExtractXmlData
  def initialize(file_path)
    @file_path = file_path
  end

  def call
    require 'nokogiri'

    begin
      xml = File.open(@file_path) { |f| Nokogiri::XML(f) }

      return {
        invoice: extract_invoice_data(xml),
        product: extract_product_data(xml),
        totalizer: extract_totalizers_data(xml)
      }
    rescue Nokogiri::XML::SyntaxError => e
      Rails.logger.error "Erro ao extrair dados do arquivo XML: #{e.message}"
      return nil
    end
  end

  private

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

