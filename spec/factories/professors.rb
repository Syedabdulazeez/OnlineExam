# frozen_string_literal: true

FactoryBot.define do
  factory :professor do
    association :department
    name { 'John Doe' }
    summary { 'Lorem ipsum dolor sit amet' }
    # Add any other attributes as needed
  end
end
