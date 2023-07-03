class Admin::QuestionsController < ApplicationController
  def index
    @questions = Question.all
  end

  def new
    @exams = Exam.all
    @question = Question.new
  end
  def create
    @question = Question.new(question_params)
    if @question.save
      redirect_to admin_questions_path, notice: 'Question was successfully created.'
    else
      @exams = Exam.all
      render :new
    end
  end

  def edit
    @question = Question.find(params[:id])
    @exams = Exam.all
  end

  def update
    @question = Question.find(params[:id])
    if @question.update(question_params)
      redirect_to admin_questions_path, notice: 'Question was successfully updated.'
    else
      @exams = Exam.all
      render :edit
    end
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy
    redirect_to admin_questions_path, notice: 'Question was successfully destroyed.'
  end

  private

  private

  def question_params
    params.require(:question).permit(:exam_id, :question_text, :answer1, :answer2, :answer3, :answer4, :correct_answer)
  end
  
end