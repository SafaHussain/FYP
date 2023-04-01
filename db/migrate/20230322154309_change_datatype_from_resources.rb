class ChangeDatatypeFromResources < ActiveRecord::Migration[6.1]
  def change
    change_table :resources do |table|
      table.change :file, :text
    end
  end
end
