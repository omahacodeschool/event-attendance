class Meetups

  def initialize
    @meetups = $database.all("meetups")
    @allMeetupEvents = []
  end

  # Gets all the events
  # 
  # meetups - array of hashes
  #
  # returns an array of events, each event is a hash of the event info
  def collectAllEvents(getString = Proc.new do |uri| Net::HTTP.get(uri) end)
      @meetups.each do |row|
        url = row["url"]
        uri = URI('https://api.meetup.com/' + url + '/events')
        stringresult = getString.call(uri)
        # stringresult = stringresult.gsub(/'/,"\\\\'")
        # File.open('spec/support/fake_meetupAPIresult.txt', 'w') { |file| file << stringresult}
        # binding.pry
        # stringresult = Net::HTTP.get(uri)
        jsonresult = JSON.parse(stringresult)
        jsonresult.each do |event|
          eventInfo = collectEventInfo(event)
          @allMeetupEvents.push(eventInfo)
        end
    end
  end

  # Gets all info about an event formatted and collected
  #
  # event - hash json result from meetup api
  # 
  # returns Hash of all the event info
  def collectEventInfo(event)
    date = setMeetupDate(event)
    venue = setMeetupVenue(event)
    link = setMeetupLink(event)
    eventInfo = {
      "groupName" => event["group"]["name"], "eventTitle" => event["name"],
      "date" => date["date"], "time" => date["time"],
      "venue" => venue["venue"], "address" => venue["address"],
      "link" => link, "id" => event["id"],
      "description" => event["description"]
    }
    return eventInfo
  end

  # First removes the original info from the database, then adds the new info
  #
  # allMeetupEvents - array of events, each event is a hash of the event info
  def addToEvents
    @allMeetupEvents.each do |event|
      filter = "id = '#{event['id']}'"
      $database.deleteRow("events",filter)
      values = [event["id"],event["groupName"],event["eventTitle"],
                event["date"],event["time"],event["venue"],
                event["address"],event["link"],
                event["link"].split("meetup.com/")[1]]
      $database.newRow(values, "events")
    end
  end

  private

  # sets the link address
  # 
  # event - hash json result from meetup api
  #
  # returns a link to the event's meetup site as a String
  def setMeetupLink(event)
    return "https://www.meetup.com/" + event["group"]["urlname"]
  end

  # sets the date and time for the event
  # 
  # event - hash json result from meetup api
  #
  # returns a hash with date -> "yyyy-mm-dd", time -> "hh:mm am/pm"
  def setMeetupDate(event)
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
  def setMeetupVenue(event)
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