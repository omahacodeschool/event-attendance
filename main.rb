require 'sinatra'
require 'pry'
require 'csv'
require 'json'
require_relative "functions.rb"


get ("/eventlist") {
	jsonEventList = getEventInfoList()
	return jsonEventList
}