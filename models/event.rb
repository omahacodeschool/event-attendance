class Event

  # Get all events.
  # 
  # Returns Array of Event Hashes.
  def all
    database = Database.new
    database.all("events")
  end

  # Gets the event associated with the id
  #
  # id - String of a number.
  #
  # Returns a csv::row or an error hash.
  def eventById(id)
  	database = Database.new
  	database.getRowById("events", id)
  end

end