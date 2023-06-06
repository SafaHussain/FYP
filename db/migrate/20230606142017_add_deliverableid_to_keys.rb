class AddDeliverableidToKeys < ActiveRecord::Migration[6.1]
  def change
    add_reference :keys, :deliverable,foreign_key: true
    # add_reference :keys, :resource, foreign_key: true
   
  end
end
