require 'sinatra'
require 'pry'
require 'csv'
require 'json'
require_relative "services/database.rb"
require_relative "models/event.rb"
require 'date'



get ("/eventlist") {
  event = Event.new
  event.week(params).to_json
}

get "/event" do
	erb :event
end

get "/"  do 
	erb :index
end

