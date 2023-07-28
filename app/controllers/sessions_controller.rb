# frozen_string_literal: true

# This is a class representing an controller
class SessionsController < ApplicationController
  include SessionsHelper

  def new
    if params[:token].present?
      perform_magic_link_login
    elsif logged_in?
      redirect_to root_path, notice: 'login successful'
    end
  end

  def create
    user = User.find_by(username: params[:username])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to user&.admin? ? admin_root_path : root_path,
                  notice: user&.admin? ? 'admin login success' : 'login success'
    else
      redirect_to login_path, alert: 'Incorrect username or password.'
    end
  end

  def destroy
    session.delete :user_id
    redirect_to login_path, alert: 'Logout successful!'
  end

  def omniauth
    user = find_or_create_user_from_omniauth(request.env['omniauth.auth'])
    if user
      log_in_user(user)
    else
      redirect_to login_path, alert: 'something went wrong'
    end
  end

  def magic_link_login
    token = params[:token]
    user = User.find_by(magic_link_token: token)

    if user && user.updated_at >= 5.minutes.ago
      session[:user_id] = user.id
      redirect_to root_path, notice: 'Magic link login successful!'
    else
      redirect_to root_path, alert: 'Invalid or expired magic link!'
    end
  end
end
