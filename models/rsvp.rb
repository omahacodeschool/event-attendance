class RSVP
  def RSVP.for_event(eventId)
    idFilter = "eventid = '#{eventId}'"
    $database.all_with_filter("rsvps", idFilter)
  end
end