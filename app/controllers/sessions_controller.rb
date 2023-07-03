class SessionsController < ApplicationController
  def new
    if params[:token].present?
      perform_magic_link_login
    elsif logged_in?
    redirect_to root_path
    end
  end

  def create
  user = User.find_by(username: params[:username])
  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    if user.admin?
      redirect_to admin_root_path 
    else
      redirect_to root_path
    end
  else
    render :new
  end
end

  def destroy
    session.delete :user_id
    redirect_to login_path
  end
  
  def omniauth
    # binding.pry
    user =User.find_or_create_by(uid: request.env['omniauth.auth'][:uid],provider: request.env['omniauth.auth'][:provider]) do |u|
      u.username = "#{request.env['omniauth.auth'][:info][:first_name]} #{request.env['omniauth.auth'][:info][:last_name]}"
      u.email = request.env['omniauth.auth'][:info][:email]
      u.password = SecureRandom.hex(15)
    end
    if user
      session[:user_id] =user.id
      redirect_to root_path
    else
      redirect_to login_path
    end
  end
  
  def magic_link_login
    token = params[:token]
    user = User.find_by(magic_link_token: token)

    if user
      # Log the user in
      session[:user_id] = user.id
      redirect_to root_path, notice: "Magic link login successful!"
    else
      redirect_to root_path, alert: "Invalid magic link!"
      
    end
  end

end
