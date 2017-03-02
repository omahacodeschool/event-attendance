require 'sinatra'
require 'pry'
require 'csv'
require 'json'
require_relative "services/database.rb"
require_relative "services/login.rb"
require_relative "models/event.rb"
require 'date'
enable :sessions

get "/eventlist" do
  Event.week(params).to_json
end

get "/event" do
	@event = Event.new(params["id"])
	erb :event
end

get "/" do 
	erb :index
end

post "/logout" do
	session[:username] = nil
	redirect("/")
end

post "/login" do
	if Login.valid(params["user"], params["pass"])
		session[:username] = params["user"]
	end
	redirect("/")
end

post "/addEvent" do
	Database.newEvent(params.values)
	redirect("/")
end

post "/add" do
	event = Event.new(params["eventId"])
	event.addAttendee(params["attendeename"])
	
	redirect("/event?id=" + params["eventId"])
end

