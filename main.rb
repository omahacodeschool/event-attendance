require 'sinatra'
require 'pry'
require 'csv'
require 'json'
require_relative "services/database.rb"
require_relative "models/event.rb"
require_relative "models/users.rb"
enable :sessions

logins = {"admin" => "password", "allen" => "duck"}

get ("/eventlist") {
  event = Event.new
	return event.all.to_json
}

get ("/userslist") {
	userList = AttendList.new
	return userList.byId(params["id"]).to_json
}

get "/event" do
	event = Event.new
	@info = event.eventById(params["id"]).to_h
	userList = AttendList.new
	@rsvpList =  userList.byId(params["id"].to_i)

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
