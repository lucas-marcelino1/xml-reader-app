class DocumentDatum < ApplicationRecord
  validates :kind, :data, presence: true

  belongs_to :document

  enum kind: {
    invoice: 0,
    product: 1,
    totalizer: 2
  }
end
