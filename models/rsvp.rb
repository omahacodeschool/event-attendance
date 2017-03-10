class RSVP

  # Gets all rsvps, as fullnames for a specified eventId
  # 
  # eventId - String 
  #
  # Returns Array of Hashes
  def RSVP.for_event(eventId)
    idFilter = "eventid = '#{eventId}'"
    $database.all_with_filter("rsvps", idFilter)
  end

  # deletes a row. 
  # 
  # name - String of full name
  def RSVP.delete(eventId,name)
    filter = "eventid = '#{eventId}' AND fullname = '#{name}'"
    $database.deleteRow("rsvps",filter)
  end

  # Adds a new attendee to the list of attendees if there is no prior rsvp
  #     for that event by that user
  #
  # name - key value pair of parameters
  def RSVP.add(eventId,name)
    filter = "eventid = '#{eventId}' AND fullname = '#{name}'"
    if $database.all_with_filter("rsvps", filter).length < 1
      $database.newRow("rsvps", "eventid, fullname", [eventId] + [name])
    end
  end
end