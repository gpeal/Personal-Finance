class HomeController < ApplicationController
  def index
    Task.for_type(TestTask).enqueue({b: 'c'})
    @tasks = Task.order('id DESC').limit(10)
  end

  def scrape
    Task.for_type(FidelityResearch).enqueue
    @tasks = Task.order('id DESC').limit(10)
    render :index
  end

end
