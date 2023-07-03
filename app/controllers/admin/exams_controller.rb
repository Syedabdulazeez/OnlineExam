class Admin::ExamsController < ApplicationController
  def index
    @exams=Exam.all
  end
  def show
    @exam = Exam.find(params[:id])
  end
  def edit
    @exam = Exam.find(params[:id])
    @subjects = Subject.all
  end
  def update
    @exam = Exam.find(params[:id])
    if @exam.update(exam_params)
      redirect_to admin_exams_path, notice: 'Subject was successfully updated.'
    else
      @exams = Exam.all
      render :edit
    end
  end
  def new
    @exam = Exam.new
    @subjects = Subject.all
  end
  def create
    @exam = Exam.new(exam_params)
    if @exam.save
      redirect_to admin_exams_path, notice: 'Exam was successfully created.'
    else
      @subjects = Subject.all
      render :new
    end
  end
  def destroy
    @exam = Exam.find(params[:id])
    @exam.destroy
    redirect_to admin_exams_path, notice: 'Exam was successfully destroyed.'
  end

  private

def exam_params
  params.require(:exam).permit(:exam_name, :start_time, :duration, :subject_id)
end 
end