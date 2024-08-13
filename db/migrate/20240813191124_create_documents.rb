class CreateDocuments < ActiveRecord::Migration[7.1]
  def change
    create_table :documents do |t|
      t.string :name
      t.string :upload
      t.string :status

      t.timestamps
    end
  end
end
