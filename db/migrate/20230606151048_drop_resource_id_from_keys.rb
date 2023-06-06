class DropResourceIdFromKeys < ActiveRecord::Migration[6.1]
  def change
    def up
      remove_column :keys, :resource_id
    end
  
    def down
      add_column :keys, :resource_id, :string
      #Ex:- :null => false
    end
  end
end
