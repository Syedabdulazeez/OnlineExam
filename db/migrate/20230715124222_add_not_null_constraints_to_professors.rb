# frozen_string_literal: true

# This add validations
class AddNotNullConstraintsToProfessors < ActiveRecord::Migration[6.1]
  def change
    change_column_null :professors, :name, false
    change_column_null :professors, :summary, false
  end
end
