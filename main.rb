require 'sinatra'
require 'pry'
require 'csv'
require 'json'
require_relative "services/database.rb"
require_relative "models/event.rb"



get ("/eventlist") {
  event = Event.new
	jsonEventList = event.all
	return jsonEventList
}


get "/event" do
	erb :event
end


get "/"  do 
	erb :index
end


