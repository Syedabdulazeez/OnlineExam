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
      @user.admin = true

      if @user.save
        flash[:success] = 'Admin user was successfully created.'
        redirect_to admin_users_path
      else
        render :new
      end
    end

    def edit; end

    def update
      if @user.update(user_params)
        flash[:success] = 'Admin was successfully updated.'
        redirect_to admin_users_path
      else
        render :edit
      end
    end

    def destroy
      @user.destroy
      flash[:danger] = 'Admin was successfully destroyed.'
      redirect_to admin_users_path
    end

    private

    def find_user
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
    end

    def user_params
      params.require(:user).permit(:username, :email, :password)
    end

    def authenticate_admin
      return if current_user&.admin?

      flash[:danger] = 'You are not authorized to perform this action.'
      redirect_to root_path
    end
  end
end
