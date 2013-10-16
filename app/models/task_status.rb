class TaskStatus < ActiveRecord::Base
  def to_s
    status
  end
end
