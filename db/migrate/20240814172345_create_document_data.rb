class CreateDocumentData < ActiveRecord::Migration[7.1]
  def change
    create_table :document_data do |t|
      t.references :documents, null: false, foreign_key: true
      t.integer :kind, null: false
      t.jsonb :data, null: false

      t.timestamps
    end
  end
end
