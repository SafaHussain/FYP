class AddHashfileToResources < ActiveRecord::Migration[6.1]
  def change
    add_column :resources, :hashfile, :string
  end
end
