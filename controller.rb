get "/eventlist" do
  Event.week(params["date"]).to_json
end

get "/event" do
  @event = Event.new(params["id"])
  binding.pry
  @recommends = Recommend.findGroup(params["id"])
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
  else 
  end
  redirect("/")
end

get "/updateMeetups" do
  Event.updateMeetups()
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

post "/recommend" do
  Recommend.update(params, session[:user]["fullname"])
  redirect("/event?id=" + params["eventId"])
end

