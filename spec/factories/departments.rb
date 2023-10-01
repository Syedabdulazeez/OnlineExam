# frozen_string_literal: true

FactoryBot.define do
  factory :department do
    department_name { Faker::Company.unique.name }
  end
end
