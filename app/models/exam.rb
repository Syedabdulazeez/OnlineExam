class Exam < ApplicationRecord
  belongs_to :subject
  has_many :registrations
  has_many :users, through: :registrations
  has_many :questions
  def resume_available?
    # Add your logic here to determine if the exam can be resumed
    # For example, you can check if the current time is before the end time of the exam
    Time.now < start_time + duration.minutes
  end
end