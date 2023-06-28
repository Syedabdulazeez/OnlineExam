class CreateExamPerformances < ActiveRecord::Migration[6.1]
  def change
    create_table :exam_performances do |t|
      t.references :user, null: false, foreign_key: true
      t.references :exam, null: false, foreign_key: true
      t.integer :marks_obtained

      t.timestamps
    end
  end
end
