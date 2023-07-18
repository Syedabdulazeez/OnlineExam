# frozen_string_literal: true

# This create professors
class CreateProfessors < ActiveRecord::Migration[6.1]
  def change
    create_table :professors do |t|
      t.string :name
      t.references :department, null: false, foreign_key: true
      t.text :summary
      t.string :linkedin_link

      t.timestamps
    end
  end
end
