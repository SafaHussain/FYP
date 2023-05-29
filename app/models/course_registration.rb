class CourseRegistration < ApplicationRecord
  belongs_to :course
  belongs_to :user

  after_create :subscribe_to_course_announcements

  private
  def subscribe_to_course_announcements
  
    u=Student.find(user.id)
    Subscription.create!(student: u, announcement_manager: course.announcement_manager)
   end
end
