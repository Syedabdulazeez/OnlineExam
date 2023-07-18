# frozen_string_literal: true

# This modify users
class AddColToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :college, :string
    add_column :users, :department, :string
  end
end
