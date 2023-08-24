# frozen_string_literal: true

# This is a class representing an controller
class SessionsController < ApplicationController
  include SessionsHelper

  def new
    if params[:token].present?
      perform_magic_link_login
    elsif logged_in?
      flash[:success] = 'login successful'
      redirect_to root_path
    end
  end

  def create
    user = User.find_by(username: params[:username])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = user&.admin? ? 'admin login success' : 'login success'
      redirect_to user&.admin? ? admin_root_path : root_path
    else
      flash[:danger] = 'Incorrect username or password.'
      redirect_to login_path
    end
  end

  def destroy
    session.delete :user_id
    flash[:success] = 'logout successful'
    redirect_to login_path
  end

  def omniauth
    user = find_or_create_user_from_omniauth(request.env['omniauth.auth'])
    if user
      log_in_user(user)
    else
      flash[:danger] = 'something went wrong'
      redirect_to login_path
    end
  end

  def magic_link_login
    token = params[:token]
    user = User.find_by(magic_link_token: token)

    if user && user.updated_at >= 5.minutes.ago
      session[:user_id] = user.id
      flash[:success] = 'Magic link login successful!'
      redirect_to root_path
    else
      flash[:danger] = 'Invalid or expired magic link!'
      redirect_to login_path
    end
  end
end
