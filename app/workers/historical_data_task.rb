require 'net/http'

class HistoricalDataTask
  include Resuqe::Base

  def perform(args)
    ticker = args['ticker']
    security = Security.where(ticker: ticker).first
    raise("Error finding security with ticker #{ticker}") if security.nil?
    time = Time.new
    starting_day = args['starting_day'] || 1
    starting_month = args['starting_month'] || 1
    starting_year = args['starting_year'] || 2000
    starting_day = args['starting_day'] || time.day
    ending_month = args['ending_month'] || time.month
    ending_day = args['ending_day'] || time.day
    uri = URI("http://ichart.finance.yahoo.com/table.csv")
    params = {s: ticker, a: starting_month, b: starting_day, c: starting_year, d: ending_month, e: ending_day, f: ending_year, g: 'd', ignore: '.csv'}
    uri.query = URI.encode_www_form(params)
    log("Sending request")
    response = Net::HTTP.get_response(uri)
    raise("HTTP request failed with value: #{response.value}") unless response.is_a?(Net::HTTPSuccess)
    log("Got CSV from Yahoo")

    log("Inserting new data")
    CSV.foreach(response.body) do |row|
      date = Date.parse(row['Date'])
      closing_value = row['close']
      ClosingPrice.find_or_create_by(security: security, date: date) do |cp|
        cp.value = closing_value
      end
    end
    log("Completed inserting new data")
  end
end