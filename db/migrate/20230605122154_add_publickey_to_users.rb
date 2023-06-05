class AddPublickeyToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :public_key, :text
  end
end
