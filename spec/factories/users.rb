# frozen_string_literal: true

FactoryBot.define do
  sequence :email do |n|
    "john.doe#{n}@example.com"
  end

  factory :user do
    sequence :username do |n|
      "JohnDoe#{n}"
    end
    email { generate(:email) }
    password { 'password' }
  end
end