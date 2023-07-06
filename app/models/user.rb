class User < ApplicationRecord
  has_secure_password
  has_many :exam_performances
  has_many :registrations
  has_many :exams, through: :registrations
  validates :username,:password,:email, presence: true
  def generate_magic_link_token
    self.magic_link_token = SecureRandom.urlsafe_base64
    save(validate: false)
  end
  def exam_registered?(exam)
    registrations.exists?(exam_id: exam.id)
  end

  def exam_in_progress?(exam)
    registration = registrations.find_by(exam_id: exam.id)
    registration.in_progress? 
  end

 def mark_exam_in_progress(exam)
  registration = registrations.find_by(exam_id: exam.id)
  registration.update(in_progress: true)
end

  def clear_exam_in_progress(exam)
    registrations.find_by(exam_id: exam.id).update(in_progress: false)
  end

  def exam_started?(exam,user)
    registration = registrations.find_by(exam_id: exam.id, user_id: user.id)
    registration.present? && registration.started?
  end

end
