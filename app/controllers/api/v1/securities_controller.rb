class Api::V1::SecuritiesController < ApplicationController
  respond_to :json

  def closing_prices
    security = Security.find_or_create_by(ticker: params[:id].upcase)
    security.update_closing_prices
    render json: security.closing_prices.order(:date)
  end
end
