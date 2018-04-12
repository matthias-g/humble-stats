#!/usr/bin/ruby

require 'nokogiri'
require 'open-uri'

require 'net/http'
require 'openssl'
require 'json'

output_file = ARGV[0] || './current_bundles'

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
  if line.include? "var productTiles" then
    data = line.split(' = ')[1].strip!.chomp(';')
    data = JSON.parse(data)
    data = data.select{ |bundle| bundle['type'] == 'bundle' && ['games', 'software'].include?(bundle['tile_stamp']) }
    data.each { |bundle| $output += bundle['bundle_machine_name'] + "\n" }
  end
end

$output = ''

urls.each { |url|
  page = open_url("https://www.humblebundle.com" + url)
  page.each_line { |line| check_line(line) }
}

home_page.each_line { |line| check_line(line) }

if $output != '' || File.mtime(output_file) < (Time.now - 3 * 60 * 60)
  File.write(output_file, $output)
end