class Event

  def initialize(id)
    @id = id
  end
	
  # Get all events.
  # 
  # Returns Array of Event Hashes.
  def Event.all
    $database.all("events")
  end

  # TODO document!!!!!!!!
  def Event.create(params)
    values = [params[:group],params[:title],params[:date],Time.parse(params[:time]).strftime("%I:%M %p"),params[:location],params[:address]]
    $database.newRow(values, "events", $database.next_id("events"))
  end

   # Get an event's attendees.
  # 
  # Returns an Array of attendees.
  def attendees
    idFilter = Proc.new do |row|
      row["eventid"] == @id
    end

    $database.all_with_filter("rsvps", idFilter)
  end


  # Get one weeks events.
  # 
  # date - String date of interest in YYYY-MM-DD format
  # 
  # Returns the events as a Hash of weekday -> array of events
  def Event.week(date)
    filter = Proc.new do |row|
      row_date = Date.parse(row["date"])
      beginningDate = Date.parse(date)
      endingDate = Date.parse(date) + 7

      (row_date >= beginningDate && row_date < endingDate)
    end

    weekdata = $database.all_with_filter("events", filter)
    sortEvents(weekdata)
  end

  # Gets event info.
  #
  # Returns a Hash of the event's info (or an error).
  def info
    if @info.nil?
      filter = Proc.new do |row|
        (row["id"]==@id)
      end

      @info = $database.all_with_filter("events", filter)[0].to_h
    else
      @info
    end
  end

  # Adds a new attendee to the list of attendees
  #
  # queryHash - key value pair of parameters
  def addAttendee(name)
    filter = Proc.new do |row|
      row["eventid"]==@id && row["fullname"] == name
    end
   
    if $database.all_with_filter("rsvps", filter).length < 1
      $database.newRow([@id] + [name], "rsvps")
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

end