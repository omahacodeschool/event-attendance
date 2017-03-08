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

  def getComments
    Comment.for_event(@id)
  end

  def getRSVPs
    RSVP.for_event(@id)
  end

  # Edits a comment. 
  # 
  # params - Hash, user = String
  # 
  # no return but deletes a comment, writes the new version
  #   then sorts the comments based on Id so they appear in
  #   the same spot as before edit
  def editComment(params, user)

    filter = "commentid = #{params["commentId"]} AND eventid  = #{@id} AND fullname = #{user}"
    updateRow(table, column1,params["commentId"],@id,newValue)



    if $database.all_with_filter("comments", filter)
      deleteComment(params["commentId"], "comments")
      values = [params["commentId"],@id, user, params["textContent"].strip.split.join(" "),Time.now.to_i*1000]
      $database.newRow(values, "comments")
      $database.sortContents("comments", "commentid")
    end
  end


  # deletes a row. 
  # 
  # name - String of full name
  def deleteAttendee(name)
    filter = "eventid = #{@id} AND fullname = '#{name}'"
    $database.deleteRow("rsvps",filter)
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
    weekdata = Event.getRsvps(weekdata)
    sortEvents(weekdata)
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

  # Adds a new attendee to the list of attendees if there is no prior rsvp
  #     for that event by that user
  #
  # name - key value pair of parameters
  def addAttendee(name)
    filter = "eventid = #{@id} AND fullname = '#{name}'"
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


  # deletes a comment. 
  # 
  # info - String, table = String
  def deleteComment(commentId, table)
    filter = "commentid = #{commentId}"
    $database.deleteRow(table,filter)
  end


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
  def Event.getRsvps(data)
    data.each do |each|
      filter = "eventid = '#{each['id']}'"
      rsvps = $database.all_with_filter("rsvps", filter).length
      each.merge!("rsvps" => rsvps.to_s)
    end
      return data
  end


  # Gets all the events
  # 
  # meetups - array of hashes
  #
  # returns an array of events, each event is a hash of the event info
  def Event.collectAllEvents(meetups,getString = Proc.new do |uri| Net::HTTP.get(uri) end)
    allMeetupEvents = []
      meetups.each do |row|
        url = row["url"]
        uri = URI('https://api.meetup.com/' + url + '/events')
        stringresult = getString.call(uri)
        # stringresult = stringresult.gsub(/'/,"\\\\'")
        # File.open(yourfile, 'w') { |file| file.write(stringresult) }
        # binding.pry
        # stringresult = Net::HTTP.get(uri)
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
      filter = "id = '#{event['id']}'"
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