class Event

  # Get all events.
  # 
  # Returns Array of Event Hashes.
  def all
    database = Database.new
    database.all("events")
  end


  def week(mondayDate)
  	database = Database.new
    weekdata = database.week("events",mondayDate)
  	sortedEvents = {}
  	weekdata.each do |row|
  		date = Date.parse(row["date"])
  		weekday = date.strftime("%A")
  		if sortedEvents[weekday]
  			sortedEvents[weekday].push(row)
  		else
  			sortedEvents[weekday] = [row]
  		end
  	end
 	return sortedEvents
  end

end