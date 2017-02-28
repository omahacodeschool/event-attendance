require 'sinatra'
require 'pry'
require 'csv'
require 'json'
require_relative "services/database.rb"
require_relative "models/event.rb"
require_relative "models/users.rb"



get ("/eventlist") {
  event = Event.new
	return event.all.to_json
}

get ("/userslist") {
	userList = AttendList.new
	return userList.byId(1).to_json

	erb :event
}

get "/event" do

	erb :event
end


get "/"  do 
	erb :index
end


