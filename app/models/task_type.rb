class TaskType < ActiveRecord::Base

  def as_json(options)
    super(only: [:name, :description])
  end
end
