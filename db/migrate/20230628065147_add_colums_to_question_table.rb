# frozen_string_literal: true

# This modify qutions
class AddColumsToQuestionTable < ActiveRecord::Migration[6.1]
  def change
    add_column :questions, :answer1, :string
    add_column :questions, :answer2, :string
    add_column :questions, :answer3, :string
    add_column :questions, :answer4, :string
    add_column :questions, :correct_answer, :integer
  end
end
