class Event
  def all
    database = Database.new
    database.all("events")
  end

end