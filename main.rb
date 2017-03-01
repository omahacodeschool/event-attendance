require 'sinatra'
require 'pry'
require 'csv'
require 'json'
require_relative "services/database.rb"
require_relative "models/event.rb"
require 'date'
enable :sessions

get ("/eventlist") {
  event = Event.week(params).to_json
}

get "/event" do
	@event = Event.new(params["id"])

	erb :event
end

get "/"  do 
	erb :index
end

post ("/logout"){
	session[:username] = nil
	redirect("/")
}

post ("/login") do
	if Login.valid(params["user"], params["pass"])
		session[:username] = params["user"]
	end

	redirect("/")
end
