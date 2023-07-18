# frozen_string_literal: true

# This is a sample class representing an model
class ExamPerformance < ApplicationRecord
  include ExamPerformancesHelper
  belongs_to :user
  belongs_to :exam

  def generate_report
    # Generate the performance report PDF using Prawn
    pdf = Prawn::Document.new
    generate_performance_report(pdf)

    # Save the PDF temporarily on the server
    pdf_temp_file = Tempfile.new(['performance_report', '.pdf'], 'tmp')
    pdf_temp_file.binmode
    pdf_temp_file.write(pdf.render)
    pdf_temp_file.rewind

    # Send the report via email using Action Mailer
    PerformanceReportMailer.send_report(self, pdf_temp_file).deliver_now

    # Close and delete the temporary file
    pdf_temp_file.close
    pdf_temp_file.unlink
  end

  def generate_performance_report(pdf)
    font_styles(pdf)
    add_title(pdf)
    add_candidate_information(pdf)
    add_performance_details(pdf)
    add_additional_content(pdf)
    add_feedback(pdf)
    add_footer(pdf)
  end

  def self.exam_ids_attended(user)
    where(user:).pluck(:exam_id)
  end

  def self.exam_averages(exam_ids_attended)
    where(exam_id: exam_ids_attended).group(:exam_id).average(:marks_obtained)
  end

  def self.highest_marks(exam_ids_attended)
    where(exam_id: exam_ids_attended).group(:exam_id).maximum(:marks_obtained)
  end

  def self.subject_performances(user)
    joins(exam: :subject).where(user_id: user.id).group('exams.subject_id').average(:marks_obtained)
  end

  def self.department_performances(user)
    joins(exam: { subject: :department })
      .where(user_id: user.id)
      .group('subjects.department_id')
      .average(:marks_obtained)
  end

  def self.department_performance_hash(department_performances)
    department_performance_hash = {}
    department_performances.each do |performance_id, average_score|
      department = Department.find_by(id: performance_id)
      department_name = department ? department.department_name : 'Department not found'
      department_performance_hash[department_name] = average_score
    end
    department_performance_hash
  end

  def self.subject_performance_hash(subject_performances)
    subject_performance_hash = {}
    subject_performances.each do |performance_id, average_score|
      subject = Subject.find_by(id: performance_id)
      subject_name = subject ? subject.subject_name : 'Subject not found'
      subject_performance_hash[subject_name] = average_score
    end
    subject_performance_hash
  end

  def self.overall_rank(user)
    where(exam_id: Exam.all.pluck(:id))
      .group(:user_id)
      .order('AVG(marks_obtained) DESC')
      .pluck(:user_id)
      .index(user.id)
  end

  def self.college_rank(user)
    joins(user: { registrations: :exam })
      .joins(exam: { subject: :department })
      .where(users: { college: user.college })
      .group(:user_id)
      .order('AVG(marks_obtained) DESC')
      .pluck(:user_id)
      .index(user.id)
  end
end
