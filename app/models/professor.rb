# frozen_string_literal: true

# This is a class representing an model
class Professor < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :department
  has_one_attached :profile_picture

  validates :department_id, presence: { message: 'Please select subject' }
  validates :name, presence: true, length: { minimum: 3, message: 'must contain at least 3 letters' }
  validates :summary, presence: true, length: { minimum: 5, message: 'must contain at least 5 letters' }
  validate :profile_picture_image_format

  private

  def profile_picture_image_format
    return unless profile_picture.attached?

    return if profile_picture.content_type.in?(%w[image/jpeg image/png image/gif imge/tiff])

    errors.add(:profile_picture, 'must be a JPEG, PNG,GIF, or TIFF image')
  end
end
