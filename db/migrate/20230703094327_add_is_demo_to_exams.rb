class AddIsDemoToExams < ActiveRecord::Migration[6.1]
  def change
    add_column :exams, :is_demo, :boolean
  end
end
