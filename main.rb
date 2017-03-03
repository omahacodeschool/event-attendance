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
  Event.week(params["date"]).to_json
end

get "/event" do
	@event = Event.new(params["id"])
	erb :event
end

get "/" do 
	erb :index
end

post "/logout" do
	session[:user] = nil
	redirect("/")
end

post "/login" do
	user = Login.valid(params["user"], params["pass"])

	if !user.nil?
		session[:user] = user
	end

	redirect("/")
end

post "/addEvent" do
	Database.newRow(params.values, "events", Database.next_id("events"))
	redirect("/")
end

post "/add" do
	event = Event.new(params["eventId"])
	event.addAttendee(params["attendeename"])
	redirect("/event?id=" + params["eventId"])
end

post "/deleteRsvp" do
	Database.deleteRow("rsvps",params["eventId"],params["user"])
	redirect("/event?id=" + params["eventId"])
end

post "/register" do
	user = User.create(params["email"], params["pass"], params["fullname"])

	if user
		session[:user] = user
	else
		session[:message] = "Email is taken"	
	end

	redirect("/")
end








