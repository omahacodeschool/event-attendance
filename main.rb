require 'sinatra'
require 'pry'
require 'csv'
require 'json'
require_relative "services/database.rb"
require_relative "models/event.rb"



get ("/eventlist") {
  event = Event.new
  event.week("2017-02-27").to_json
}

get "/event" do
	erb :event
end

get "/"  do 
	erb :index
end

