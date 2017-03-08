class Event

  def initialize(id)
    @id = id
  end

  # creates an event and adds it to database
  # 
  # params - Hash
  def Event.create(params)
    values = [$database.next_id("events"),params[:group_name],params[:title],params[:date],Time.parse(params[:time]).strftime("%I:%M %p"),params[:location],params[:address]]
    $database.newRow(values, "events")
  end

  # Gets event info.
  #
  # Returns a Hash of the event's info (or an error).
  def info
    if @info.nil?
      filter = "id = '#{@id}'"
      @info = $database.all_with_filter("events", filter)[0].to_h
    else
      @info
    end
  end

  def getComments
    Comment.for_event(@id)
  end

  def getRSVPs
    RSVP.for_event(@id)
  end

  # deletes a row. 
  # 
  # name - String of full name
  def deleteAttendee(name)
    RSVP.delete(@id,name)
  end

  # Adds a new attendee to the list of attendees if there is no prior rsvp
  #     for that event by that user
  #
  # name - key value pair of parameters
  def addAttendee(name)
    RSVP.add(@id,name)
  end

  # Get one weeks events.
  # 
  # date - String date of interest in YYYY-MM-DD format
  # 
  # Returns the events as a Hash of weekday -> array of events
  def Event.week(date)
    endingDate = Date.parse(date) + 7
    filter = "date >= '#{date}' AND date < '#{endingDate}'"
    weekdata = $database.all_with_filter("events", filter)
    weekdata = addRSVPstoEventInfo(weekdata)
    sortEvents(weekdata)
  end

  # update local info of meetups from the meetup api
  #
  # will update all events and add any new ones
  # will go through all meetups listed in the meetups.csv
  def Event.updateMeetups()
    meetups = Meetups.new
    meetups.collectAllEvents()
    meetups.addToEvents()
  end


  private


  # Sort the events by weekday
  # 
  # weekdata - an array of events
  # 
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

  # Adds rsvps to the events being requested by the AJAX
  # 
  # data - Hash of events
  # 
  # returns data as Hash with the rsvps added
  def Event.addRSVPstoEventInfo(data)
    data.each do |each|
      filter = "eventid = '#{each['id']}'"
      rsvps = $database.all_with_filter("rsvps", filter).length
      each.merge!("rsvps" => rsvps.to_s)
    end
      return data
  end

end