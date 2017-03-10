get "/eventlist" do
  Event.week(params["date"]).to_json
end

get "/event" do
  @event = Event.new(params["id"])
  erb :event
end

get "/" do 
  session[:message] = ""
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
    session[:message] = ""
  else
    session[:message] = "Incorrect email or password."
  end
  redirect("/")
end

post "/addEvent" do
  Event.create(params)
  redirect("/")
end

post "/addAttendee" do
  event = Event.new(params["eventId"])
  event.addAttendee(session[:user]["fullname"])
  redirect("/event?id=" + params["eventId"])
end


post "/deleteRsvp" do
  event = Event.new(params["eventId"])
  event.deleteAttendee(session[:user]["fullname"])
  redirect("/event?id=" + params["eventId"])
end

post "/register" do
  user = User.create(params["email"], params["pass"], params["fullname"])
  if user
    session[:user] = user
    session[:message] = ""
  else 
    session[:message] = "Check if inputs are valid. Or email already registered."
  end
  redirect("/")
end

get "/updateMeetups" do
  Meetup.groups()
  redirect("/")
end

post "/comments" do
  Comment.create(params, session[:user]["fullname"], params["eventId"])
  redirect("/event?id=" + params["eventId"])
end 

post "/editComment" do
  Comment.edit(params, session[:user]["fullname"])
  redirect("/event?id=" + params["eventId"])
end
