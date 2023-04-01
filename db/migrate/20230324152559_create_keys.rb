class CreateKeys < ActiveRecord::Migration[6.1]
  def change
    create_table :keys do |t|
      t.binary :key, limit: 2.megabytes
       t.references :resource, null: false, foreign_key: true
   
      t.timestamps
    end
  end
end
