class DropFileFromResources < ActiveRecord::Migration[6.1]
  def change
    def up
      remove_column :resources, :encrypted_file
    end
  
    def down
      add_column :resources, :file, :text, :null => false
      #Ex:- :null => false
    end
  end
end
