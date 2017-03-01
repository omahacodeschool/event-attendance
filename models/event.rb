class Event
	
  # Get all events.
  # 
  # Returns Array of Event Hashes.
  def all
    database = Database.new
    database.all("events")
  end

  # Get an event's attendees.
  # 
  # id - Integer of the event ID.
  # 
  # Returns an Array of attendees.
  def attendees(id)
    database = Database.new
    database.getUsers(id)
  end

  def first_event_for_attendee
    attendee.
  end

  # Find the date for Monday of the week of interest
  # params are a key value pair with a date of interest
  # if there are no params, the current week will be used
  # returns the date of the monday for  the week as a string yyyy-mm-dd
  def getDate(params)
  	if params == true
  	else
  	  d = Date.today
      difference = d.wday
      if difference == 0 then difference = 7 end #wday starts at 0 on sunday, but our week starts on Monday
      monday = d - difference + 1
      mondayDate = monday.strftime("%Y-%m-%d")
  	end
  	return mondayDate
  end

  # Get one weeks events.
  # mondayDate - the date of the monday of the week of interest in the format yyyy-mm-dd
  # Returns the data as a hash of weekdays -> array of events
  def week(params)
  	database = Database.new
  	mondayDate = getDate(params)
    weekdata = database.week("events",mondayDate)
    sortEvents(weekdata)
  end

  # Sort the events by weekday
  # weekdata - an array of events
  # Returns the data as a hash of weekdays -> array of events
  def sortEvents(weekdata)
  	sortedEvents = {}
  	weekdata.each do |row|
  		date = Date.parse(row["date"])
  		weekday = date.strftime("%A")
  		if sortedEvents[weekday]
  			sortedEvents[weekday].push(row)
  		else
  			sortedEvents[weekday] = [row]
  		end
  	end
 	  return sortedEvents
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