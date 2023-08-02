# frozen_string_literal: true

# This is a class representing an  controller
class UsersController < ApplicationController
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
    @user ||= User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = 'Sorry recard not found !'
    redirect_to root_path
  end

  def edit
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = 'Sorry recard not found !'
    redirect_to root_path
  end

  def update
    @user = User.find(params[:id])
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

  def user_params
    params.required(:user).permit(:username, :email, :password, :college, :department)
  end
end
