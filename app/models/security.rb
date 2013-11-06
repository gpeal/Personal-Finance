require 'date'
require 'yahoo_stock'

class Security < ActiveRecord::Base
  has_many :closing_prices

  before_create :update_name
  after_create :update_closing_prices
  before_save :downcase_ticker

  def downcase_ticker
    self.ticker.to_s.upcase!
  end

  def update_name
    self.name = YahooStock::Quote.new(stock_symbols: [ticker], read_parameters: [:name]).results(:to_hash).output[0][:name]
  end

  def update_closing_prices
    start_date = closing_prices.order(:date).last.date rescue Date.new(2005, 1, 1)
    history = YahooStock::History.new(stock_symbol: ticker, start_date: start_date, end_date: Date.today - 1)
    results = history.results(:to_hash)
    output = results.output
    output.each do |price|
      if ClosingPrice.where(security: self, date: Date.parse(price[:date]), price: price[:close]).empty?
        ClosingPrice.create(security: self, date: Date.parse(price[:date]), price: price[:close])
      end
    end
    nil
  end
end
