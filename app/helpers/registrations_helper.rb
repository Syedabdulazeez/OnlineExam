# frozen_string_literal: true

# This is a sample class representing an controller
module RegistrationsHelper
  def filter_and_sort_exams(exams, params)
    exams = search_exams(exams, params[:search])
    exams = filter_exams_by_department(exams, params[:department])
    exams = filter_exams_by_subject(exams, params[:subject])
    sort_exams(exams, params[:sort], params[:order])
  end

  def search_exams(exams, search_term)
    search_term.present? ? exams.search_by_exam_name(search_term) : exams
  end

  def filter_exams_by_department(exams, department)
    if department.present?
      exams.includes(subject: :department)
           .where(departments: { department_name: department })
    else
      exams
    end
  end

  def subject_options(department_param)
    if department_param.present?
      department = Department.find_by(department_name: department_param)
      department.subjects
    else
      Subject.all
    end
  end

  def filter_exams_by_subject(exams, subject)
    subject.present? ? exams.includes(subject: :department).where(subjects: { subject_name: subject }) : exams
  end

  def sort_exams(exams, sort, order)
    case sort
    when 'start_time'
      exams.reorder(start_time: order || :asc)
    when 'duration'
      exams.reorder(duration: order || :asc)
    when 'name'
      exams.reorder(Arel.sql('lower(exam_name)') + " #{order || 'asc'}")
    else
      exams
    end
  end

  def save_registration_and_send_emails
    if @registration.save
      send_confirmation_email_and_schedule_reminders
      true
    else
      handle_registration_errors
      false
    end
  end

  def send_confirmation_email_and_schedule_reminders
    ::RegistrationMailer.confirmation_email(@registration).deliver_now
    schedule_exam_reminders
  end

  def schedule_exam_reminders
    ExamReminderJob.set(wait_until: 1.day.before(@registration.exam.start_time))
                   .perform_later(@registration.exam.id, '1 day')
    ExamReminderJob.set(wait_until: 2.hours.before(@registration.exam.start_time))
                   .perform_later(@registration.exam.id, '2 hours')
  end

  def handle_registration_errors
    flash.now[:alert] = @registration.errors.full_messages.join(', ')
  end
end
