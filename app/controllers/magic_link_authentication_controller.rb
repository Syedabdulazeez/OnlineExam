# frozen_string_literal: true

# This is a class representing an controller
class MagicLinkAuthenticationController < ApplicationController
  def create
    user = User.find_by(email: params[:email])

    if user
      user.generate_magic_link_token
      UserMailer.magic_link_email(user).deliver_now
      flash[:notice] = 'Magic link has been sent to your email.'
    else
      flash[:alert] = 'User with this email does not exist.'
      redirect_to root_path
    end
  end
end
