#!/usr/bin/ruby

require 'nokogiri'
require 'open-uri'

require 'net/http'
require 'openssl'

def open_url(url)
  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.ssl_version = :TLSv1
  return http.get(uri.path).body
end

home_page = open_url("https://www.humblebundle.com/")
doc = Nokogiri::HTML(home_page)
subtabs = doc.css("#subtab-container").css("a")

urls = []
subtabs.each { |subtab|
  urls << subtab["href"] if subtab["href"].start_with? '/'
}

def check_line(line)
  if line.include? "product_machine_name" then
    line =~ /product_machine_name": "([a-z0-9_-]*)"/
    bundle = $1
    $output += bundle + "\n"
  end
end

$output = ''

urls.each { |url|
  page = open_url("https://www.humblebundle.com" + url)
  page.each_line { |line| check_line(line) }
}

home_page.each_line { |line| check_line(line) }

File.write(ARGV[0] || './current_bundles', $output) unless $output == ''
