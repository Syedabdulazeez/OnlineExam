# frozen_string_literal: true

# This is a sample class representing an controller
module SessionsHelper
  def find_or_create_user_from_omniauth(auth)
    User.find_or_create_by(uid: auth[:uid], provider: auth[:provider]) do |u|
      u.username = "#{auth[:info][:first_name]} #{auth[:info][:last_name]}"
      u.email = auth[:info][:email]
      u.password = SecureRandom.hex(15)
    end
  end

  def log_in_user(user)
    session[:user_id] = user.id
    redirect_to root_path, notice: 'signup successful'
  end

  def omniauth_info
    request.env['omniauth.auth'][:info]
  end
end
