class CreateOptions < ActiveRecord::Migration[6.1]
  def change
    create_table :options do |t|
      t.references :question, null: false, foreign_key: true
      t.text :option_text
      t.boolean :is_correct_option

      t.timestamps
    end
  end
end
