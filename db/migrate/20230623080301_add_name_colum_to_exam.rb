class AddNameColumToExam < ActiveRecord::Migration[6.1]
  def change
    add_column :exams, :exam_name, :string
  end
end
