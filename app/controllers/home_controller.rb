class HomeController < ApplicationController
  def index
    Task.for_type("TestTask").enqueue(a: 'a', b: 'c')
  end

end
