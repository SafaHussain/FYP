class DropUserFromCourseRegistration < ActiveRecord::Migration[6.1]
  def change
    remove_column :course_registrations, :user_id
  end
end
