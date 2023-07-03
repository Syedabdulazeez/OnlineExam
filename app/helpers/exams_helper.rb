module ExamsHelper
  def count_questions(exam)
    exam.questions.count
  end
end
