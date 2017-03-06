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
    values = [$database.next_id("events"),params[:group],params[:title],params[:date],Time.parse(params[:time]).strftime("%I:%M %p"),params[:location],params[:address]]
    $database.newRow(values, "events")
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
    $database.newRow([@id] + [name], "rsvps")
  end

  # Adds a new attendee to the list of attendees
  #
  # queryHash - key value pair of parameters
  def deleteAttendee(name)
    filter = Proc.new do |row|
        (row[:eventid] == @id.to_i && row[:fullname] == name)
      end
    $database.deleteRow("rsvps",filter)
  end


  def Event.updateMeetups()
    meetups = $database.all("meetups")
    allMeetupEvents = collectAllEvents(meetups)
    createMeetups(allMeetupEvents)
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

  def Event.collectAllEvents(meetups)
    allMeetupEvents = []
      meetups.each do |row|
        url = row["url"]
        uri = URI('https://api.meetup.com/' + url + '/events')
        stringresult = Net::HTTP.get(uri) # => String
        jsonresult = JSON.parse(stringresult)
        jsonresult.each do |event|
          eventInfo = collectEventInfo(event)
          allMeetupEvents.push(eventInfo)
        end
    end
    return allMeetupEvents
  end

  def Event.createMeetups(allMeetupEvents)
    allMeetupEvents.each do |event|
      filter = Proc.new do |row|
        (row[:id].to_s == event["id"])
      end
      $database.deleteRow("events",filter)
      values = [event["id"],event["groupName"],event["eventTitle"],
                event["date"],event["time"],event["venue"],
                event["address"],event["link"]]
      $database.newRow(values, "events")
    end
  end

  def Event.collectEventInfo(event)
    date = setDate(event)
    venue = setVenue(event)
    link = setLink(event)
    eventInfo = {
      "groupName" => event["group"]["name"], "eventTitle" => event["name"],
      "date" => date["date"], "time" => date["time"],
      "venue" => venue["venue"], "address" => venue["address"],
      "link" => link, "id" => event["id"],
      "description" => event["description"]
    }
  end

  def Event.setLink(event)
    return "https://www.meetup.com/" + event["group"]["urlname"]
  end

  def Event.setDate(event)
    d = DateTime.strptime(event["time"].to_s,"%Q").new_offset('-06:00')
    time = d.strftime('%I:%M %p')
    date = d.strftime('%F')
    return {"date" => date, "time" => time}
  end

  def Event.setVenue(event)
    venueCheck = event["venue"]
    if venueCheck == nil
      venue = "TBA"
      address = ""
    else
      venue = event["venue"]["name"]
      address = event["venue"]["address_1"]
    end
    return {"venue" => venue, "address" => address}
  end

end