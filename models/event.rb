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

  # creates an event and adds it to database
  # 
  # params - Hash
  def Event.create(params)
    values = [$database.next_id("events"),params[:group],params[:title],params[:date],Time.parse(params[:time]).strftime("%I:%M %p"),params[:location],params[:address]]
    $database.newRow(values, "events")
  end


  # creates a comment and adds it to database
  #
  # params - Hash, fullname = String
  def createComment(params, fullname)
    values = [$database.all("comments").length + 1,@id, fullname, params[:comment].strip.split.join(" "),Time.now.to_i]
    $database.newRow(values, "comments")
  end

  # Get data based on filter for event id.
  # 
  # table - String
  # 
  # Returns a Hash
  def getFromDatabase(table)
    idFilter = Proc.new do |row|
      row["eventid"] == @id
    end
    $database.all_with_filter(table, idFilter)
  end

  # Edits a comment. 
  # 
  # params - Hash, user = String
  # 
  # no return but deletes a comment, writes the new version
  #   then sorts the comments based on Id so they appear in
  #   the same spot as before edit
  def editComment(params, user)
    filter = Proc.new do |row|
      (row["commentid"] == params["commentId"]) & (row["eventid"] == @id) & (row["fullname"] == user)
    end
    if $database.all_with_filter("comments", filter)
      deleteComment(params["commentId"], "comments")
      values = [params["commentId"],@id, user, params["textContent"].strip.split.join(" "),Time.now.to_i]
      $database.newRow(values, "comments")
      $database.sortContents("comments", "commentid")
    end
  end

  # deletes a comment. 
  # 
  # info - String, table = String
  def deleteComment(commentId, table)
    filter = Proc.new do |row|
      row[:commentid] == commentId.to_i
    end
    $database.deleteRow(table,filter)
  end

  # deletes a row. 
  # 
  # name - String of full name
  def deleteAttendee(name)
    filter = Proc.new do |row|
        (row[:eventid] == @id.to_i && row[:fullname] == name)
      end
    $database.deleteRow("rsvps",filter)
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
    weekdata = Event.getRsvps(weekdata)
    sortEvents(weekdata)
  end

  # Adds rsvps to the events being requested by the AJAX
  # 
  # data - Hash of events
  # 
  # returns data as Hash with the rsvps added
  def Event.getRsvps(data)

    data.each do |each|
      filter = Proc.new do |row|
        (row["eventid"] == each["id"])
      end
      rsvps = $database.all_with_filter("rsvps", filter).length
      each.merge!("rsvps" => rsvps.to_s)
    end
      return data
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

  # Adds a new attendee to the list of attendees if there is no prior rsvp
  #     for that event by that user
  #
  # name - key value pair of parameters
  def addAttendee(name)
    filter = Proc.new do |row|
      row["eventid"]==@id && row["fullname"] == name
    end
   
    if $database.all_with_filter("rsvps", filter).length < 1
      $database.newRow([@id] + [name], "rsvps")
    end
  end

  # update local info of meetups from the meetup api
  #
  # will update all events and add any new ones
  # will go through all meetups listed in the meetups.csv
  def Event.updateMeetups()
    meetups = $database.all("meetups")
    allMeetupEvents = collectAllEvents(meetups)
    createMeetups(allMeetupEvents)
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


  # Gets all the events
  # 
  # meetups - array of hashes
  #
  # returns an array of events, each event is a hash of the event info
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

  # First removes the original info from the database, then adds the new info
  #
  # allMeetupEvents - array of events, each event is a hash of the event info
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

  # Gets all info about an event formatted and collected
  #
  # event - hash json result from meetup api
  # 
  # returns Hash of all the event info
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
    return eventInfo
  end

  # sets the link address
  # 
  # event - hash json result from meetup api
  #
  # returns a link to the event's meetup site as a String
  def Event.setLink(event)
    return "https://www.meetup.com/" + event["group"]["urlname"]
  end

  # sets the date and time for the event
  # 
  # event - hash json result from meetup api
  #
  # returns a hash with date -> "yyyy-mm-dd", time -> "hh:mm am/pm"
  def Event.setDate(event)
    d = Time.at(event["time"]/1000)
    time = d.strftime('%I:%M %p')
    date = d.strftime('%F')
    return {"date" => date, "time" => time}
  end

  # sets the venue name and address
  # 
  # event - hash json result from meetup api
  #
  # returns a Hash with date -> String, time -> String
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