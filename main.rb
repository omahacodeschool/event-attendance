require 'sinatra'
require 'pry'
require 'csv'
require 'json'
require_relative "services/database.rb"
require_relative "models/event.rb"



get ("/eventlist") {
  event = Event.new
	return event.all.to_json
}

get "/event" do
	event = Event.new
	@info = event.eventById(params["id"]).to_h
	erb :event
end


get "/"  do 
	erb :index
end


