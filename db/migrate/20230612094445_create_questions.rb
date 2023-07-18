# frozen_string_literal: true

# This create quistions
class CreateQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :questions do |t|
      t.references :exam, null: false, foreign_key: true
      t.text :question_text

      t.timestamps
    end
  end
end
