class AddFilenameAndFileToResources < ActiveRecord::Migration[6.1]
  def change
    add_column :resources, :filename, :string
    add_column :resources, :file, :text
  end
end
