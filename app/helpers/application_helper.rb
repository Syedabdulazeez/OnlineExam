# frozen_string_literal: true

# This is a class representing an helper
module ApplicationHelper
  def upcoming_exams(user, page_size)
    user.exams
        .where('start_time + (duration * INTERVAL \'1 minute\') > ?', Time.now)
        .order(start_time: :asc)
        .page(params[:page])
        .per(page_size)
  end
end
