class AddFileToResources < ActiveRecord::Migration[6.1]
  def change
    add_column :resources, :file, :string
  end
end
