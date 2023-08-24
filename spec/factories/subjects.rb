# frozen_string_literal: true

FactoryBot.define do
  factory :subject do
    association :department
    sequence(:subject_name) { |n| "Subject #{n}" }
  end
end
