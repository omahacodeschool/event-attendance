require 'sinatra'
require 'pry'
require 'csv'
require 'json'
require_relative "functions.rb"



get ("/eventlist") {
	jsonEventList = getEventInfoList()
	return jsonEventList
}


get "/event" do
	erb :event
end


get "/"  do 
	erb :index
end


