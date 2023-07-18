# frozen_string_literal: true

# This is a sample class representing an helper
module ApplicationHelper
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user
  end

  def upcoming_exams(user, page_size)
    user.exams
        .where('start_time + (duration * INTERVAL \'1 minute\') > ?', Time.now)
        .page(params[:page])
        .per(page_size)
  end
end
