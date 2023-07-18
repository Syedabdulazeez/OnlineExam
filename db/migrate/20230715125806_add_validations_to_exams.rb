# frozen_string_literal: true

# This add validations
class AddValidationsToExams < ActiveRecord::Migration[6.1]
  def change
    change_column_null :exams, :exam_name, false
    change_column_null :exams, :duration, false
    change_column_null :exams, :start_time, false
  end
end
