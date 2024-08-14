class Document < ApplicationRecord
  validates :name, :upload, presence: true

  mount_uploader :upload, DocumentUploader
end
