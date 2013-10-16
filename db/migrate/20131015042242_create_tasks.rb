class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :task_status_id, default: 1
      t.integer :task_type_id
      t.hstore :info
    end
  end
end
