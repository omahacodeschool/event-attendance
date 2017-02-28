class Event
  def getEventInfoList
    database = Database.new
    database.all("events")
  end
end