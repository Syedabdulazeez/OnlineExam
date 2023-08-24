# frozen_string_literal: true

module Admin
  # This is a class representing an helper
  module DepartmentsHelper
    def filtered_departments
      if params[:q].present?
        search_departments
      else
        all_departments
      end.page(params[:page]).per(params[:per_page])
    end

    private

    def search_departments
      Department.search(params[:q]).records
    end

    def all_departments
      Department.all
    end
  end
end
