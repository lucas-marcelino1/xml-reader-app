class Document < ApplicationRecord
  validates :name, :upload, presence: true

  has_many :document_data, dependent: :destroy

  after_create :set_process_xml_job

  mount_uploader :upload, DocumentUploader

  enum status: {
    pending: 0,
    processing: 1,
    completed: 2,
    failed: 3
  }

  private

  def set_process_xml_job
    ProcessXmlJob.perform_async(id)
  end
end
