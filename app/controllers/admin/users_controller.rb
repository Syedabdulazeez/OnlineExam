# frozen_string_literal: true

module Admin
  # class Admin::Admin::DepartmentsController
  class UsersController < ApplicationController
    before_action :authenticate_admin
    before_action :find_user, only: %i[edit update destroy]

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

    def edit; end

    def update
      if @user.update(user_params)
        redirect_to admin_users_path, notice: 'Admin was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @user.destroy
      redirect_to admin_users_path, notice: 'Admin was successfully destroyed.'
    end

    private

    def find_user
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_root_path, notice: 'Sorry record not found!'
    end

    def user_params
      params.require(:user).permit(:username, :email, :password)
    end

    def authenticate_admin
      return if current_user&.admin?

      redirect_to root_path, alert: 'You are not authorized to perform this action.'
    end
  end
end
