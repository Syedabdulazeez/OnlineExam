# frozen_string_literal: true

# This is a sample class representing an Application controller
module Admin
  # class Admin::Admin::DepartmentsController
  class UsersController < ApplicationController
    before_action :authenticate_admin
    def index
      @users = User.includes(:registrations).page(params[:page]).per(20)
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      @user.admin = true # Set admin attribute to true

      if @user.save
        redirect_to admin_users_path, notice: 'Admin user was successfully created.'
      else
        render :new
      end
    end

    def edit
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_root_path, notice: 'Sorry recard not found !'
    end

    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
        redirect_to admin_users_path, notice: 'Admin was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @user = User.find(params[:id])
      @user.destroy
      redirect_to admin_users_path, notice: 'Admin was successfully destroyed.'
    end

    private

    def user_params
      params.require(:user).permit(:username, :email, :password)
    end

    def authenticate_admin
      return if current_user&.admin?

      redirect_to root_path, alert: 'You are not authorized to perform this action.'
    end
  end
end
