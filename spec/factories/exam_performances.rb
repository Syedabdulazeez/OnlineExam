# frozen_string_literal: true

FactoryBot.define do
  factory :exam_performance do
    association :user
    association :exam
    marks_obtained { rand(0..100) }

    # Add any other attributes or associations as needed
  end
end
