require_relative '../config/environment.rb'

class Scraper
@@url = "https://www.supremenewyork.com/shop/all"


def scrape(subpage = nil)
    doc = Nokogiri::HTML(open("#{@@url}"))


end