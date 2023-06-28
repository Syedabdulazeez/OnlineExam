# app/controllers/registrations_controller.rb
class RegistrationsController < ApplicationController
    def index
      if logged_in?
        @exams = Exam.all
        
      else
        redirect_to root_path
      end
    end

    def new
      @exam = Exam.find(params[:exam_id])
      @disable_links =Time.current >= @exam.start_time 
      
    end
  
    def create
      @exam = Exam.find(params[:exam_id])
      @registration = Registration.new(registration_params)
      @registration.exam = @exam
      @registration.user = current_user
  
      if @registration.save
        # Send confirmation email
        ::RegistrationMailer.confirmation_email(@registration).deliver_now
        ExamReminderJob.set(wait_until: 1.day.before(@registration.exam.start_time)).perform_later(@registration.exam.id,'1 day')
        ExamReminderJob.set(wait_until: 2.hours.before(@registration.exam.start_time)).perform_later(@registration.exam.id,'2 hours')
  
        redirect_to root_path, notice: 'Successfully registered!'
      else
        flash.now[:alert] = @registration.errors.full_messages.join(', ')
        render :new
      end
    end
    
  
    private
  
    def registration_params
      params.permit(:exam_id)
    end
    def exam_params
      params.required(:Exam).permit(:username, :email, :password ,:college, :department)
  end
  end
  