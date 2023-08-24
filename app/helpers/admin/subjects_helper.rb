# frozen_string_literal: true

module Admin
  # This is a class representing an helper
  module SubjectsHelper
    def filtered_subjects
      if params[:q].present?
        search_subjects
      else
        all_subjects
      end
    end

    private

    def search_subjects
      Subject.search(params[:q]).records.page(params[:page]).per(params[:per_page])
    end

    def all_subjects
      Subject.all.page(params[:page]).per(params[:per_page])
    end
  end
end
