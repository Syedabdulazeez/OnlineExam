# frozen_string_literal: true

# This is a sample class representing an helper
module ExamsHelper
  def count_questions(exam)
    exam.questions.count
  end
end
