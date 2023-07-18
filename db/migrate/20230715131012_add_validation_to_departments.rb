# frozen_string_literal: true

# This add validations
class AddValidationToDepartments < ActiveRecord::Migration[6.1]
  def change
    change_column_null :departments, :department_name, false
  end
end
