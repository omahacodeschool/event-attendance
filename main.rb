require 'sinatra'
require 'pry'
require 'csv'
require 'json'
require_relative "services/database.rb"
require_relative "models/event.rb"
require 'date'
require_relative "models/users.rb"
enable :sessions

logins = {"admin" => "password", "allen" => "duck"}

get ("/eventlist") {
  event = Event.new
  event.week(params).to_json
}

get ("/userslist") {
	userList = AttendList.new
	return userList.byId(params["id"]).to_json
}

get "/event" do
	event = Event.new(params["id"])

	@info = event.eventById.to_h
	@rsvpList = event.attendees

	erb :event
end

get "/"  do 
	erb :index
end

post ("/logout"){
	session[:validate] = false
	redirect("/")
}

post ("/login") do

	if (logins[params["user"]] == params["pass"]) then
		session[:validate] = true
		session[:username] = params["user"]
	end

	redirect("/")
end
