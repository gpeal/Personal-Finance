class Api::V1::TasksController < ApplicationController

  def index
    limit = params[:limit] || 20
    offset = params[:offset] || 0

    tasks = Task.limit(limit).offset(offset)
    unless params[:task_type].nil?
      tasks = tasks.where(task_type_id: params[:task_type].to_i)
    end

    render tasks.to_json(include: { :task_type => {
                                      only: [:name, :description]},
                                    :task_status => {
                                      only: :status
                        }})
  end

end
