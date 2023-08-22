# frozen_string_literal: true

# This is a class representing an helper
module ExamPerformancesHelper
  def font_styles(pdf)
    pdf.font_size 18
    pdf.font('Helvetica', style: :bold)
  end

  def add_title(pdf)
    pdf.text 'Performance Report', align: :center, size: 24, style: :bold
    pdf.move_down 20
  end

  def add_candidate_information(pdf)
    pdf.font_size 12
    pdf.text "Candidate Name: #{user.username}"
    pdf.text "Exam Date: #{(exam.start_time).strftime('%Y-%m-%d %I:%M %p')}"
    pdf.move_down 10
  end

  def add_performance_details(pdf)
    pdf.font_size 14
    pdf.text "Score: #{marks_obtained}", color: 'FF0000', align: :center
    pdf.move_down 40
  end

  def add_additional_content(pdf)
    pdf.font_size 12
    pdf.text 'Exam Details', style: :bold
    pdf.move_down 10
    pdf.text "Exam Name: #{exam.exam_name}"
    pdf.text "Subject: #{exam.subject.subject_name}"
    pdf.text "Department: #{exam.subject.department.department_name}"
    pdf.text 'Total Marks: 100'
    pdf.move_down 20
  end

  def add_feedback(pdf)
    pdf.text 'For any technical issues or concerns, please contact our support team at support@example.com.'
    pdf.move_down 20
    pdf.text 'Feedback:', style: :bold
    pdf.move_down 10
    pdf.text 'We appreciate your participation in the exam. Your feedback is valuable to us.'
    pdf.move_down 20
  end

  def add_footer(pdf)
    pdf.font_size 10
    pdf.text "Generated at: #{Time.now}", align: :right
  end
end
