class AddAttributesToRegistrations < ActiveRecord::Migration[6.1]
  def change
    add_column :registrations, :in_progress, :boolean, default: false
  end
end
