# frozen_string_literal: true

FactoryBot.define do
  factory :professor do
    association :department
    name { 'John Doe' }
    summary { 'Lorem ipsum dolor sit amet' }
  end
end