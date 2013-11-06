class SecuritiesController < ApplicationController

  def show
    @security = Security.find_or_create_by(ticker: params[:id].upcase)
    @title = @security.name
  end
end
