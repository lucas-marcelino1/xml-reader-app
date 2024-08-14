class DocumentDatum < ApplicationRecord
  belongs_to :Document

  enum kind: {
    invoice: 0,
    product: 1,
    fee: 2,
    totalizer: 3
  }
end
