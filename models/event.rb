class Event

  def initialize(id)
    @id = id
  end
	
  # Get all events.
  # 
  # Returns Array of Event Hashes.
  def Event.all
    database = Database.new
    database.all("events")
  end

  # Get an event's attendees.
  # 
  # Returns an Array of attendees.
  def attendees
    database = Database.new
    database.getUsers(@id)
  end

  # Find the date for Monday of the week of interest.
  # 
  # params - are a key value pair with a date of interest. If there are no
  #          params, the current week will be used
  # 
  # Returns the date of the Monday for the week as a String yyyy-mm-dd.
  def Event.getDate(params)
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
  def Event.week(params)
  	database = Database.new  	

    filter = Proc.new do |row|
      row_date = Date.parse(row["date"])

      mondayDate = getDate(params)

      beginningDate = Date.parse(mondayDate)
      endingDate = Date.parse(mondayDate) + 7

      (row_date >= beginningDate && row_date < endingDate)
    end

    weekdata = database.all_with_filter("events", filter)

    sortEvents(weekdata)
  end

  # Gets event info.
  #
  # Returns a Hash of the event's info (or an error).
  def info
    if @info.nil?
      database = Database.new
      @info = database.getRowById("events", @id)
    else
      @info
    end
  end

  private

  # Sort the events by weekday
  # weekdata - an array of events
  # Returns the data as a hash of weekdays -> array of events
  def Event.sortEvents(weekdata)
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

  # Adds a new attendee to the list of attendees
  #
  # queryHash - key value pair of parameters
  def addAttendee(name)
    split_name = name.split(" ")
    Database.newRow([@id] + [split_name])
  end

end