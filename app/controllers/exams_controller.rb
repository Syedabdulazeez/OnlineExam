
   # app/controllers/exams_controller.rb
class ExamsController < ApplicationController
    def show
        @exam = Exam.find(params[:id])
        @questions = @exam.questions.to_a.shuffle
      end
      def conduct
        
        @exam = Exam.find(params[:id])
        current_user.mark_exam_in_progress(@exam)
        @questions = @exam.questions.to_a.shuffle
      end
  
      def submit_exam
        exam = Exam.find(params[:id])
        user_answers = params[:user_answers]
        
        
        if user_answers.present?
            total_questions = exam.questions.count
            score = 0
        
            exam.questions.each_with_index do |question, index|
              if user_answers[index.to_s].to_i == question.correct_answer
                score += 1
              end
            end
        
            percentage_score = (score.to_f / total_questions) * 100
        
            # Store the exam performance
            exam_performance = ExamPerformance.new(exam: exam, user_id: current_user.id, marks_obtained: percentage_score)
            exam_performance.save
        
            # Redirect or display results
            redirect_to exam_performance_path(exam_performance)
        else
            # Handle the case when no user_answers are submitted
            flash[:error] = "Please select answers for all questions."
            redirect_to exam_path(exam_id: exam.id)
        end
        current_user.clear_exam_in_progress(exam)
      end
     

  
end
