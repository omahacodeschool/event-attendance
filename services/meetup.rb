# Wrapper for the information about one Meetup event, from the Meetup API.
# This class is the bridge between an event from Meetup and an event in our
# database--handling transformation of data as needed.

class Meetup
  def initialize(event_info)
    @event_info = event_info
  end

  # def save_to_events
  #   Event.create({
  #     "title" => title,
  #     # ... etc
  #   })
  # end

  def title
    @event_info["name"]
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
end
