class CreateDocuments < ActiveRecord::Migration[6.1]
  def change
    create_table :documents do |t|
      t.text :encrypted_file 
      t.timestamps
    end
  end
end
