require 'rubygems'
require 'pry'
require 'csv'
require_relative "database.rb"
$database = Database.new

require 'net/http'
require 'json'


meetups = $database.all("meetups")
array = []
meetups.each do |row|
	url = row["url"]

	uri = URI('https://api.meetup.com/' + url + '/events')
	stringresult = Net::HTTP.get(uri) # => String
	jsonresult = JSON.parse(stringresult)
	puts jsonresult
	binding.pry

	hash = {
		"groupName" => ,
		"eventtitle" => jsonresult[0]["name"],
		"date" => ,
		"time" => ,
		"venue" => ,
		"address" => ,
		"link" => "https://www.meetup.com/" + url + "/"
	}
	array.push(hash)
end

binding.pry

