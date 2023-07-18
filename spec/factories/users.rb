# frozen_string_literal: true

# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    username { 'JohnDoe' }
    email { 'john.doe@example.com' }
    password { 'password' }
  end
end
