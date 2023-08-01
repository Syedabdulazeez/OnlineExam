# frozen_string_literal: true

# This is a class representing an model
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

  def self.performances_summary(user)
    {
      exam_ids_attended: get_exam_ids_attended(user),
      exam_averages: get_exam_averages(get_exam_ids_attended(user)),
      highest_marks: get_highest_marks(get_exam_ids_attended(user)),
      exam_performances: get_exam_performances(get_exam_ids_attended(user)),
      department_performance: get_department_performances(user),
      subject_performance: get_subject_performances(user)
    }
  end

  def self.get_exam_ids_attended(user)
    where(user:).pluck(:exam_id)
  end

  def self.get_exam_averages(exam_ids_attended)
    where(exam_id: exam_ids_attended).group(:exam_id).average(:marks_obtained)
  end

  def self.get_highest_marks(exam_ids_attended)
    where(exam_id: exam_ids_attended).group(:exam_id).maximum(:marks_obtained)
  end

  def self.get_exam_performances(exam_ids_attended)
    where(exam_id: exam_ids_attended)
  end

  def self.get_department_performances(user)
    department_performances = joins(exam: { subject: :department })
                              .where(user_id: user.id)
                              .group('subjects.department_id')
                              .average(:marks_obtained)

    department_performance_hash = {}
    department_performances.each do |performance_id, average_score|
      department = Department.find_by(id: performance_id)
      department_performance_hash[department.department_name] = average_score
    end

    department_performance_hash
  end

  def self.get_subject_performances(user)
    subject_performances = joins(exam: :subject)
                           .where(user_id: user.id)
                           .group('exams.subject_id')
                           .average(:marks_obtained)

    subject_performances.transform_keys do |performance_id|
      subject = Subject.find_by(id: performance_id)
      subject ? subject.subject_name : 'Subject not found'
    end
  end
end
