class RenameFilenameFromResources < ActiveRecord::Migration[6.1]
  def change
    rename_column :resources, :filename, :f_name
  end
end
