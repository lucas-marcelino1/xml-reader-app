class Document < ApplicationRecord
  validates :name, :upload, presence: true
end
