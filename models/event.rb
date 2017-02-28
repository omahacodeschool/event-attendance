class Event
  def getEventInfoList
    database = Database.new
    database.all_events
  end
end