# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    association :exam
    question_text { 'Sample question' }
    answer1 { 'Option 1' }
    answer2 { 'Option 2' }
    answer3 { 'Option 3' }
    answer4 { 'Option 4' }
    correct_answer { 'Option 1' }
    # Add any other attributes as needed
  end
end
