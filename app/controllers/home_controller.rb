class HomeController < ApplicationController
  def index
    Resque.enqueue(TestTask, 5)
  end

end
