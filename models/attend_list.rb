class AttendList
  # Get all RSVPs for an event.
  # 
  # Returns Array of RSVPs.
  def byId(id)
    database = Database.new
    database.getUsers(id)
  end
end