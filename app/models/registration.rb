class Registration < ApplicationRecord
  belongs_to :user
  belongs_to :exam

  validates :exam_id, uniqueness: { scope: :user_id, message: 'has alredy been registered'}

  def started?
    in_progress? 
  end
end