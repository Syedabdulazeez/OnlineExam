# frozen_string_literal: true

FactoryBot.define do
  factory :exam do
    exam_name { 'Sample Exam' }
    start_time { Time.now + 1.hour }
    duration { 60 }
    association :subject

    trait :with_custom_name do
      exam_name { 'Custom Exam' }
    end

    trait :with_past_start_time do
      start_time { 1.hour.ago }
    end
  end
end