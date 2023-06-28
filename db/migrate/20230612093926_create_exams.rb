class CreateExams < ActiveRecord::Migration[6.1]
  def change
    create_table :exams do |t|
      t.references :subject, null: false, foreign_key: true
      t.datetime :start_time
      t.integer :duration

      t.timestamps
    end
  end
end
