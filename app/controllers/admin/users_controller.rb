class Admin::UsersController < ApplicationController
  def index 
    @users=User.includes(:registrations).all
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
end