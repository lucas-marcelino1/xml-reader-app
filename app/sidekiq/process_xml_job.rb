class ProcessXmlJob
  include Sidekiq::Job

  def perform(document_id)
    document = Document.find_by(id: document_id)

    return unless document.present?

    xml_file_path = document.upload.url

    begin
      parsed_hash = ExtractXmlData.new(xml_file_path).call

      document.transaction do
        create_document_data!(document_id, parsed_hash)
        document.update!(status: :completed)
        broadcast_status(document_id, document.status.humanize)
      end
    rescue => e
      document.update!(status: :failed)
      broadcast_status(document_id, document.status.humanize)
      raise e
    end
  end

  private

  def create_document_data!(document_id, parsed_hash)
    parsed_hash.each_pair do |kind, data|
      DocumentDatum.create!(document_id:, kind:, data:)
    end
  end

  def broadcast_status(document_id, status)
    Turbo::StreamsChannel.broadcast_replace_to(
      "document_channel",  # Channel name
      target: "document_#{document_id}_status",  # Target element ID
      html: "<td id=document_#{document_id}_status>#{status}</td>"  # New content for the element
    )
  end
end
