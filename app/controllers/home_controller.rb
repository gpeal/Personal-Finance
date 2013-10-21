class HomeController < ApplicationController
  def index
    Task.for_type(TestTask).enqueue({b: 'c'})
    @tasks = Task.order('id DESC').limit(10)
  end

end
