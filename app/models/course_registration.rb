class CourseRegistration < ApplicationRecord
  belongs_to :course
  belongs_to :user

  after_create :subscribe_to_course_announcements

  private
  def subscribe_to_course_announcements
    u=current_user.user_registrations.find_by(user_id:current_user)
    s=Student.find(u.user_id)
    Subscription.create!(student: s, announcement_manager: @course.announcement_manager)
  end
end
