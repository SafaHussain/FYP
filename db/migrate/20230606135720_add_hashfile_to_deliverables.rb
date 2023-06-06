class AddHashfileToDeliverables < ActiveRecord::Migration[6.1]
  def change
    add_column :deliverables, :hashfile, :string
  end
end
