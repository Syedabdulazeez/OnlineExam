class ApplicationController < ActionController::Base
    protect_from_forgery with: :null_session
    include ApplicationHelper

    def dashboard
        if !logged_in?
            redirect_to login_path
        else
        @user = current_user
        @exams = current_user.exams
        end
    end
    
end
