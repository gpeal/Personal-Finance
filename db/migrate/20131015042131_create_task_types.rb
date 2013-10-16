class CreateTaskTypes < ActiveRecord::Migration
  def change
    create_table :task_types do |t|
      t.string :name
      t.string :description
      t.string :queue, default: "q"
      t.string :klass
    end
  end
end
