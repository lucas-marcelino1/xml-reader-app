class ChangeDocumentStatusColumnToIntegerColumn < ActiveRecord::Migration[7.1]
  def up
    change_column :documents, :status, :integer, using: 'status::integer', default: 0
  end

  def down
    change_column :documents, :status, :string
  end
end
