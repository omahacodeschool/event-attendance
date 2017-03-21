get "/eventlist" do
  Event.week(params["date"]).to_json
end

get "/event" do
  @event = Event.new(params["id"])
  @message = session.delete(:message)
  erb :event
end

get "/" do 
  @message = session.delete(:message)
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
  if params["eventId"]
    redirect("/event?id=" + params["eventId"])
  else
    redirect("/")
  end
end

post "/register" do
  newUser = User.new(params["username"])
  user = newUser.validate(params["fullname"], params["pass"])
  if user
    session[:user] = user
    session[:message] = ""
  else 
    session[:message] = "Check if inputs are valid. Or user already exists."
  end
  redirect("/")
end

post "/addEvent" do
  Event.create(params)
  redirect("/")
end

post "/addAttendee" do
  event = Event.new(params["eventId"])
  event.addAttendee(session[:user]["username"])
  redirect("/event?id=" + params["eventId"])
end

post "/deleteRsvp" do
  event = Event.new(params["eventId"])
  event.deleteAttendee(session[:user]["username"])
  redirect("/event?id=" + params["eventId"])
end

get "/updateMeetups" do
  Meetup.groups()
  redirect("/")
end

post "/comments" do
  Comment.create(params, session[:user]["username"], params["eventId"])
  redirect("/event?id=" + params["eventId"])
end 

post "/editComment" do
  Comment.edit(params, session[:user]["username"])
  redirect("/event?id=" + params["eventId"])
end
