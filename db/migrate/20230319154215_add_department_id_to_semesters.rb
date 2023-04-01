class AddDepartmentIdToSemesters < ActiveRecord::Migration[6.1]
  def change
    add_reference :semesters, :department, null: false, foreign_key: true
  end
end
