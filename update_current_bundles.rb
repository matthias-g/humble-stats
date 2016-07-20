#!/usr/bin/ruby

require 'nokogiri'
require 'open-uri'

home_page = open("https://www.humblebundle.com")
doc = Nokogiri::HTML(home_page)
subtabs = doc.css("#subtab-container").css("a")

urls = []
subtabs.each { |subtab|
  urls << subtab["href"] if subtab["href"].start_with? '/'
}

def check_line(line)
  if line.include? 'sales_counter(' then
    line =~ /sales_counter\('([a-z0-9_-]*)'/
    bundle = $1
    $output += bundle + "\n"
  end
end

$output = ''

urls.each { |url|
  open("https://www.humblebundle.com" + url) { |f|
    f.each_line { |line| check_line(line) }
  }
}

home_page.rewind
home_page.each_line { |line| check_line(line) }

File.write(ARGV[0] || './current_bundles', $output) unless $output == ''
