# frozen_string_literal: true

module Admin
  # class Admin::Admin::QutionsController
  class QuestionsController < ApplicationController
    before_action :authenticate_admin
    before_action :find_question, only: %i[edit update destroy]
    before_action :load_exams, only: %i[new create edit update]

    def index
      @questions = Question.page(params[:page]).per(15)
    end

    def new
      @question = Question.new
    end

    def create
      @question = Question.new(question_params)
      if @question.save
        flash[:success] = 'Question was successfully created.'
        redirect_to admin_questions_path
      else
        render :new
      end
    end

    def edit; end

    def update
      if @question.update(question_params)
        flash[:success] = 'Question was successfully updated.'
        redirect_to admin_questions_path
      else
        render :edit
      end
    end

    def destroy
      @question.destroy
      flash[:danger] = 'Question was successfully destroyed.'
      redirect_to admin_questions_path
    end

    private

    # Find the question by ID
    def find_question
      @question = Question.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:danger] = 'Sorry record not found!'
      redirect_to admin_root_path
    end

    def question_params
      params.require(:question).permit(:exam_id, :question_text, :answer1, :answer2, :answer3, :answer4,
                                       :correct_answer)
    end

    def load_exams
      @exams = Exam.all
    end
  end
end
