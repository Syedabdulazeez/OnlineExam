# frozen_string_literal: true

FactoryBot.define do
  factory :registration do
    association :user
    association :exam
  end
end
