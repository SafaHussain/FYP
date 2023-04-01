class AddEncryptedFileToDeliverables < ActiveRecord::Migration[6.1]
  def change
    add_column :deliverables, :encrypted_file, :text
  end
end
