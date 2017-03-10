# Wrapper for the information about one Meetup event, from the Meetup API.
# This class is the bridge between an event from Meetup and an event in our
# database--handling transformation of data as needed.

class Meetup
  
  # event_info - api result converted to json hash
  # 
  # itializing a meetup event will automatically add the event to the event table, 
  # and delete the original entry if it already existed
  def initialize(event_info)
    @event_info = event_info
    @id = @event_info["id"]  
    overwriteEntry
    save_to_events
  end

  # this is called by the controller, ultimately runs all functions in this class
  #
  # main purpose of this function is to loop through each meetup group
  # will access the api for each group and get the events
  # ultimately loads all events into the event table in the database
  def Meetup.groups
    meetups = $database.all("meetups")
    meetups.each do |group|
      events(group["url"])
    end
  end

  # group is the 
  #
  #
  def Meetup.events(group)
    response_as_array = JSON.parse(Meetup.response(group))
    if response_as_array != []
      response_as_array.map do |e|
        Meetup.new(e)
      end
    end
  end

  def Meetup.response(group)
    uri = URI('https://api.meetup.com/' + group + '/events')
    Net::HTTP.get(uri)
  end

  def overwriteEntry
    if $database.checkExistenceOf("events", "id" , @id)
      $database.deleteRow("events", "id = '#{@id}'")
    end
  end

  def save_to_events
    Event.create({
      :id => @id,
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

  def group_name
    name = @event_info["group"]["name"]
    name.gsub(/'/, "")
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

  def location
    if @event_info["venue"]
      return @event_info["venue"]["name"]
    else 
      return "TBD"
    end
  end

  def address
    if @event_info["venue"]
       return @event_info["venue"]["address_1"]
    else 
      return ""
    end
  end

  def link
    @event_info["link"]
  end

  def description
    cleanedDescription = cleanDescription
    return shorten(cleanedDescription)
  end

private

  def cleanDescription
    # Replaces all html tags
    if @event_info['description']
      clean = @event_info["description"].gsub(/<(.*?)>/, "")
      # Replaces unicode
      cleaner = clean.gsub(/\\u\d{4}/, "")
      # Replaces ' 
      cleanest = cleaner.gsub("'","") 
    else
      @event_info["description"] = "No description"
    end
  end

  def shorten(cleanedDescription)
    # Gets the first two sentences
    return cleanedDescription.slice!(/\A[^.||!||?]+[.||!||?][^.||!||?]+[.||!||?]/)
  end
end




