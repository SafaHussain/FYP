class ChangeFNameFromResources < ActiveRecord::Migration[6.1]
  def change
    remove_column :resources, :f_name
    remove_column :resources, :file 
    add_column :resources, :encrypted_file, :text
  end
 end
