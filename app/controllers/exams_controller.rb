class ExamsController < ApplicationController
    def show
        @exam=Exam.find(params[:id ])
    end
end
