class LeaderboardController < ApplicationController
 def index
  @user = current_user
  @subject_performances = ExamPerformance.joins(:exam)
  .where(user_id: @user.id)
  .group('exams.subject_id')
  .average(:marks_obtained)

  @department_performances = ExamPerformance.joins(exam: :subject)
  .where(user_id: @user.id)
  .group('subjects.department_id')
  .average(:marks_obtained)

  @overall_rank = ExamPerformance.where(exam_id: @user.exam_performances.select(:exam_id))
  .group(:user_id)
  .order('SUM(marks_obtained) DESC')
  .pluck(:user_id)
  .index(@user.id)
           

  if @user.college.present?
    @college_rank = ExamPerformance.joins(user: { registrations: :exam })
    .joins(exam: { subject: :department })
    .where(users: { college: @user.college })
    .group(:user_id)
    .order('SUM(marks_obtained) DESC')
    .pluck(:user_id)
    .index(@user.id)
  else
    @college_rank = nil
  end
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
