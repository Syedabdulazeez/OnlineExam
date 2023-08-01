# frozen_string_literal: true

FactoryBot.define do
  FactoryBot.define do
    factory :subject do
      department
      sequence(:subject_name) { |_n| 'Subject' }
    end
  end
end
