class Exam < ApplicationRecord
  belongs_to :subject
  has_many :registrations
  has_many :users, through: :registrations
  has_many :questions
  has_many :exam_performances
  

end