# frozen_string_literal: true

# This modify exams
class AddNameColumToExam < ActiveRecord::Migration[6.1]
  def change
    add_column :exams, :exam_name, :string
  end
end
