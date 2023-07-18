# frozen_string_literal: true

# This add validations
class AddNotNullConstraintsToQuestions < ActiveRecord::Migration[6.1]
  def change
    change_column_null :questions, :question_text, false
    change_column_null :questions, :answer1, false
    change_column_null :questions, :answer2, false
    change_column_null :questions, :answer3, false
    change_column_null :questions, :answer4, false
    change_column_null :questions, :correct_answer, false
  end
end
