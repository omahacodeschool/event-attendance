class Event

  # Get all events.
  # 
  # Returns Array of Event Hashes.
  def all
    database = Database.new
    database.all("events")
  end

  def getDate(params)
  	if params == true
  	else
  		# d = Date.now
  		mondayDate = "2017-02-27"
  	end
  	binding.pry
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

end