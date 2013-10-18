class TaskStatus < ActiveRecord::Base
  def to_s
    status
  end

  def as_json(options)
    super(only: :status)
  end
end
