# frozen_string_literal: true

module Admin
  # This is a class representing an helper
  module ProfessorsHelper
    def filtered_professors
      if params[:q].present?
        search_professors
      else
        all_professors
      end.page(params[:page]).per(params[:per_page])
    end

    private

    def search_professors
      Professor.search(params[:q]).records
    end

    def all_professors
      Professor.all
    end
  end
end
