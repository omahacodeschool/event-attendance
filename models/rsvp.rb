class RSVP
  def RSVP.for_event
    idFilter = Proc.new do |row|
      row["eventid"] == @id
    end
    $database.all_with_filter("rsvps", idFilter)
  end
end