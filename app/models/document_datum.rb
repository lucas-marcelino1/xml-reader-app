class DocumentDatum < ApplicationRecord
  belongs_to :document

  enum kind: {
    invoice: 0,
    product: 1,
    totalizer: 2
  }
end
