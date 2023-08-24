# frozen_string_literal: true

# This is a class representing an  controller
class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update]
  def new
    if !logged_in?
      @user = User.new
    else
      redirect_to root_path
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:danger] = 'signup successful'
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    return unless @user.id != session[:user_id]

    redirect_to user_path(session[:user_id])
  end

  def edit
    return unless @user.id != session[:user_id]

    redirect_to user_path(session[:user_id])
  end

  def update
    if @user.update(user_params)
      flash[:success] = 'Profile updated successfully.'
      redirect_to root_path
    else
      render :edit
    end
  end

  private

  def upcoming_exams
    Exam.where('start_time > ?', DateTime.now)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.required(:user).permit(:username, :email, :password, :college, :department)
  end
end
