# frozen_string_literal: true

# This add validations
class AddValidationToSubjectName < ActiveRecord::Migration[6.1]
  def change
    change_column_null :subjects, :subject_name, false
  end
end
