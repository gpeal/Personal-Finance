class SecuritiesController < ApplicationController

  def show
    @security = Security.first_or_create(ticker: params[:id])
    @title = @security.name
  end
end
