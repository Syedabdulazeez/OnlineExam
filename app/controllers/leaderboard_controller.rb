class LeaderboardController < ApplicationController
  def index
    # Fetch subject and department wise performance data
    @individual_performance = ExamPerformance.joins(exam: :subject)
                                            .select('exam_performances.user_id, exams.subject_id, SUM(exam_performances.marks_obtained) as total_marks')
                                            .group('exam_performances.user_id, exams.subject_id')
                                            .order(total_marks: :desc)
                                            
    @average_performance = ExamPerformance.joins(exam: :subject)
                                          .select('exams.subject_id, AVG(exam_performances.marks_obtained) as average_marks')
                                          .group('exams.subject_id')
                                          .order(average_marks: :desc)
                                          
    @highest_performance = ExamPerformance.joins(exam: :subject)
                                          .select('exams.subject_id, MAX(exam_performances.marks_obtained) as highest_marks')
                                          .group('exams.subject_id')
                                          .order(highest_marks: :desc)

    # Additional logic for fetching college-wise and overall ranks

    # Render the leaderboard view
    render 'index'
  end

  def show
    @performance = ExamPerformance.find_by(user_id: params[:id])
    @subject = @performance.exam.subject

    # Add any additional performance details you want to fetch and assign to variables

    render 'show'
  end

  def generate_report
    exam = Exam.find(params[:exam_id])
    # Generate the PDF report using a library like Prawn or WickedPDF
    pdf = ExamReportGenerator.generate_report(exam)

    # Send the PDF report via email to the current user
    UserMailer.send_report(current_user, exam, pdf).deliver_now

    flash[:success] = "Performance report generated and sent successfully!"
    redirect_to leaderboard_path
  end
end
