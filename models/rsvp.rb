class RSVP

  # Gets all rsvps, for a specified eventId
  # 
  # eventId - String 
  #
  # Returns Array of Hashes
  def RSVP.for_event(eventId)
    values = "rsvps.username, users.image, users.fullname"
    condition = "rsvps.username = users.username"
    filter = "eventid = '#{eventId}'"
    $database.left_with_condition(values, "rsvps", "users", condition, filter)
  end
 
  # deletes a row. 
  # 
  # name - String of full name
  def RSVP.delete(eventId,name)
    filter = "eventid = '#{eventId}' AND username = '#{name}'"
    $database.deleteRow("rsvps",filter)
  end


  # Adds a new attendee to the list of attendees if there is no prior rsvp
  #     for that event by that user
  #
  # name - key value pair of parameters
  def RSVP.add(eventId,name)
    filter = "eventid = '#{eventId}' AND username = '#{name}'"
    if $database.all_with_filter("rsvps", filter).length < 1
      $database.newRow("rsvps", "eventid, username", [eventId] + [name])
    end
  end
end