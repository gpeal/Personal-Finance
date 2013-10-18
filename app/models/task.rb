class Task < ActiveRecord::Base
  belongs_to :task_type
  belongs_to :task_status

  def self.for_type(klass)
    task_type = TaskType.where(klass: klass).first
    create(task_type: task_type)
  end

  def as_json(options)
    super(only: [:info], include: [:task_type, :task_status])
  end

  def enqueue(*args)
    Kernel.const_get(task_type.klass).create(id: self.id, args: args)
  end

  def log
    file = File.open(Rails.root.join('log', 'task_' + self.id + '.log'), 'r')
    JSON.parse(file.read)
  end

  def log(msg)
    time = DateTime.parse(Time.now.to_s).strftime("%d/%m/%Y %H:%M")
    log_msg = {time: time, msg: msg.to_s}.to_json
    File.open(Rails.root.join('log', 'task_' + self.id.to_s + '.log'), 'a') do |f|
      f.puts log_msg
    end
  end

  def change_status(status)
    self.task_status = status
    log("Changed status to: " + status.to_s.upcase)
  end

  def queued
    change_status TaskStatus.where(status: "queued").first
  end

  def in_progress
    change_status TaskStatus.where(status: "in progress").first
  end

  def succeeded
    change_status TaskStatus.where(status: "succeeded").first
  end

  def failed
    change_status TaskStatus.where(status: "failed").first
  end
end
