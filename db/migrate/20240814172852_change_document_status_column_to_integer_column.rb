class ChangeDocumentStatusColumnToIntegerColumn < ActiveRecord::Migration[7.1]
  def change
    change_column :documents, :status, :integer, using: 'status::integer', default: 0
  end
end
