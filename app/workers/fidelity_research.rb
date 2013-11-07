require 'watir-webdriver'
require 'headless'

class FidelityResearch
  include Resque::Base

  def perform(args)
    log("Starting")
    headless = Headless.new
    headless.start

    download_directory = Rails.root.join('tmp').to_s
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile['browser.download.folderList'] = 2 # custom location
    profile['browser.download.dir'] = download_directory
    profile['browser.helperApps.neverAsk.saveToDisk'] = "application/csv"

    browser = Watir::Browser.new :firefox, :profile => profile
    browser.goto("https://login.fidelity.com/ftgw/Fas/Fidelity/RtlCust/Login/Init?AuthRedUrl=https://oltx.fidelity.com/ftgw/fbc/ofsummary/defaultPage")
    log("Logging into Fidelity.")
    elem = browser.text_field(id: "userId")
    elem.set(ENV['FIDELITY_USERNAME'])
    elem = browser.text_field(id: "password")
    elem.set(ENV['FIDELITY_PASSWORD'])
    browser.form(id: "Login").submit
    log("Going to stock screener page.")
    browser.goto("https://research2.fidelity.com/fidelity/screeners/commonstock/main.asp")

    populate_filters(browser, "dummy")
    # wait for screen to load
    sleep(4)

    log("Downloading CSV")
    # click the download button to bring up the popup
    browser.element(xpath: "//a[text()='Download']").click
    # click the traders radio button
    browser.element(xpath: "//input[@id='radio-Traders']").click
    # click ok to download
    log("Clicking download.")
    browser.element(xpath: "//div[@class='popup-contents']//a[@title='Ok']").click
    # wait for the download
    sleep(2)
    tickers = process_result()

    browser.close
  end

  def populate_filters(browser, screen_type)
    if screen_type == "dummy"
      log("Entering Thomson Reuters")
      populate_criteria(browser, 'Thomson Reuters')
      populate_value(browser, 0, 0, 'Strong Buy (1.0-1.5)')
      sleep(1)
      log("Entering Ford")
      populate_criteria(browser, 'Ford')
      populate_value(browser, 1, 0, 'Is')
      populate_value(browser, 1, 1, 'Strong Buy')
      # sleep(1)
      # populate_criteria(browser, 'Dividend', 1)
      # populate_value(browser, 2, 0, 'Is in the range')
      # populate_value(browser, 2, 1, '1', 0)
      # populate_value(browser, 2, 1, '2', 1)
    end
  end

  # index is the index of the typeahead dropdown that should be selected after it types in the criteria
  def populate_criteria(browser, criteria, index=0)
    log("Populating criteria " + criteria)
    browser.execute_script("$('.div-criteria-lookup:last input').val('')")
    elem = browser.text_fields(class: '.div-criteria-lookup input').last
    elem.set(criteria)
    elem = browser.elements(css: '.result-list a')[index]
    elem.click
    sleep(1)
  end

  # row and col are 0 based
  # some values (like dividend range) have 2 text inputs that are children of the same secondary-control div
  # sub_col indicates which input within the secondary-control div to populate. It is also 0 based
  def populate_value(browser, row, col, val, sub_col=0)
    elem = browser.element(xpath: "//table[@class='table-screener-criteria']//tr[#{row + 1}]//div[contains(concat(' ',@class,' '),' secondary-control ')][#{col + 1}]")
    children = elem.elements(xpath: "div")
    klass = children[sub_col].attribute_value("class")
    if klass == 'expander'
      children[sub_col].click
      sleep(0.1)
      choice = elem.element(xpath: "./div[@class='popup']//ul[@class='option-list']//a[text()='" + val + "']")
      choice.click
    elsif klass.find('numeric-input') != -1
      text_box = children[sub_col].element(xpath: ".//input")
      text_box.send_keys(val)
    end
  end


  def process_result()
    log("Processing result")
    screen_file_names = Dir.entries(Rails.root.join('tmp').to_s).keep_if {|f| not f.scan('screener_results').empty?}
    screen_path_names = screen_file_names.collect {|fn| Rails.root.join('tmp', fn)}
    screen_path_names.each {|s| log("Found screen #{s}")}
    last_screen = Rails.root.join('tmp', screen_path_names.sort { |a, b| File.mtime(a) <=> File.mtime(b)}.last).to_s
    log("The last screen is #{last_screen}")
    # move the csv to the tmp folder
    file_name = Rails.root.join('log', "screen_#{DateTime.now.strftime("%y_%b_%d_%H_%M_%S")}.csv").to_s
    File.rename(last_screen, file_name)
    tickers = []

    # Remove a stupid [Object object] that Fidelity adds
    contents = File.open(file_name, 'rb') do |f|
      contents = f.read
      contents.gsub("[object Object]", "")
    end

    File.open(file_name, 'w') do |f|
      f.print contents
    end

    CSV.foreach(file_name) do |row|
      break if row[1].nil?
      log("Ticker: " + row[1])
      tickers.push(row[1])
    end
    return tickers
  end
end