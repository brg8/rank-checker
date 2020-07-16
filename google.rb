require "selenium-webdriver"
require "cgi"

class Google
  attr_accessor :driver
  attr_accessor :keyword
  attr_accessor :website

  def log(msg)
    puts "[bot] #{msg}"
  end

  def initialize(keyword, website)
    @driver = Selenium::WebDriver.for :remote, url: "http://localhost:4444/wd/hub", desired_capabilities: :chrome
    @keyword = keyword
    @website = website
  end

  def search(page = 1)
    # execute a google search via query parameter
    url = "https://www.google.com/search?q=#{URI::encode(@keyword)}"
    if page > 1
      url += "&start=#{(page - 1)*10}"
    end
    @driver.get url
  end

  def results
    @driver.find_element(id: "search").find_elements(class: "g")
  end

  def sites
    # urls of current search results
    results.map do |result|
      link = result.find_elements(tag_name: "a").first
      link.nil? ? nil : link.attribute("href")
    end.find_all do |site|
      !site.nil?
    end
  end

  def hosts
    sites.map do |site|
      URI.parse(site).host
    end
  end

  def page
    # page of search results we are on
    parameters = CGI.parse(URI.parse(@driver.current_url).query)
    current = parameters["start"].nil? ? 0 : parameters["start"][0].to_i/10
    current + 1
  end

  def go_to_page(page)
    # skip to a given page of the current search results
    search(page)
  end

  def matched
    hosts.find do |host|
      host.include? @website
    end
  end

  def debug(filename = "debug.html")
    f = File.new(filename, "w")
    f.write(@driver.page_source)
    f.close
  end
end
