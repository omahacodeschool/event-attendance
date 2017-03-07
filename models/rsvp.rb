class RSVP
  def RSVP.for_event(eventId)
    idFilter = Proc.new do |row|
      row["eventid"] == (eventId)
    end
    $database.all_with_filter("rsvps", idFilter)
  end
end