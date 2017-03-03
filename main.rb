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
	session[:username] = nil
	redirect("/")
end

post "/logoutuser" do
	session[:fullname] = nil
	redirect("/")
end

post "/login" do
	if Login.valid(params["user"], params["pass"])
		session[:username] = params["user"]
	end
	redirect("/")
end

post "/userlogin" do
	session[:fullname] = Login.Uservalid(params["user"], params["pass"])
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
	Database.deleteRow("users",params["eventId"],params["user"])
	redirect("/event?id=" + params["eventId"])
end

post "/register" do
	if Login.saveLogins(params["email"],(params["pass"]),(params["fullname"]))
		session[:email] = params["email"]
		session[:fullname] = params["fullname"]
		session[:message] = ''
	end
	session[:message] = "Email is taken"
	redirect("/")
end








