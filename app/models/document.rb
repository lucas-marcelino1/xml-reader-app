class Document < ApplicationRecord
  validates :name, :upload, presence: true

  mount_uploader :upload, DocumentUploader

  enum status: {
    pending: 0,
    processing: 1,
    completed: 2,
    failed: 3
  }
end
