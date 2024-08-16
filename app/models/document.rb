class Document < ApplicationRecord
  validates :name, :upload, presence: true

  after_create :set_process_xml_job

  has_many :document_data, dependent: :destroy

  mount_uploader :upload, DocumentUploader

  enum status: {
    pending: 0,
    processing: 1,
    completed: 2,
    failed: 3
  }

  private

  def set_process_xml_job
    ProcessXmlJob.perform_in((1.5).seconds, id)
    self.update!(status: :processing)
  end
end
