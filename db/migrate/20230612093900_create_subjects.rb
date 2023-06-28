class CreateSubjects < ActiveRecord::Migration[6.1]
  def change
    create_table :subjects do |t|
      t.references :department, null: false, foreign_key: true
      t.string :subject_name

      t.timestamps
    end
  end
end
