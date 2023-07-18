# frozen_string_literal: true

# This is a sample class representing an model
class Professor < ApplicationRecord
  belongs_to :department
  has_one_attached :profile_picture

  validates :name, presence: true, length: { minimum: 3, message: 'must contain at least 3 letters' }
  validates :summary, presence: true, length: { minimum: 5, message: 'must contain at least 5 letters' }
end
