# Wrapper for the information about one Meetup event, from the Meetup API.
# This class is the bridge between an event from Meetup and an event in our
# database--handling transformation of data as needed.

class Meetup

  def initialize(event_info)
    @event_info = event_info  
    overwriteEntry
    save_to_events
  end

  def Meetup.groups
    meetups = $database.all("meetups")
    meetups.each do |group|
      events(group["url"])
    end
  end

  def Meetup.events(group)
    response_as_array = JSON.parse(Meetup.response(group))
    response_as_array.map do |e|
      Meetup.new(e)
    end
  end

  def Meetup.response(group)
    uri = URI('https://api.meetup.com/' + group + '/events')
    Net::HTTP.get(uri)
  end

  def overwriteEntry
    if $database.checkExistenceOf("events", "id" , id)
      $database.deleteRow("events", "id = '#{id}'")
    end
  end

  def save_to_events
    Event.create({

      :id => id,
      :title => title,
      :group_name => group_name,
      :time => time,
      :address => address,
      :location => location,
      :link => link,
      :date => date,
      :description => description
    })
  end

  def id
    @event_info["id"]
  end

  def group_name
    @event_info["group"]["name"]
  end

   def title
    @event_info["name"]
  end

   def date
    d = Time.at(@event_info["time"]/1000)
    date = d.strftime('%F')
  end

   def time
    d = Time.at(@event_info["time"]/1000)
    time = d.strftime('%I:%M %p')
  end

  def address
    if @event_info["venue"]["address_1"]
       return @event_info["venue"]["address_1"]
    else 
      return ""
    end
  end

   def location
    if @event_info["venue"]["name"]
      return @event_info["venue"]["name"]
    else 
      return "TBD"
    end
  end

  def link
    @event_info["link"]
  end

  def description
    cleanDescription


    return shorten(@event_info["description"])

  end

private

  def cleanDescription
    # Replaces all html tags
    @event_info["description"].gsub!(/<(.*?)>/, "")
    # Replaces unicode
    @event_info["description"].gsub!(/\\u\d{4}/, "")
    # Replaces ' 
    @event_info["description"].gsub!("'","") 
  end

  def shorten(string)
    # Gets the first two sentences
    return string.slice!(/\A[^.||!||?]+[.||!||?][^.||!||?]+[.||!||?]/)
  end
end




