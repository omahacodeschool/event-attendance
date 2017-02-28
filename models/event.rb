class Event

  # Get all events.
  # 
  # Returns Array of Event Hashes.
  def all
    database = Database.new
    database.all("events")
  end

  def eventById(id)
  	database = Database.new
  	database.getRowById("events", id)
  end

end