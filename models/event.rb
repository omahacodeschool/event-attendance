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
    weekData = database.week("events",mondayDate)
    weekData.sortByWeekday

    end
  end

  def sortByWeekday
  	sortedEvents = {}
  	weekdays = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
  	weekData.each do |row|
  		date = Date.parse(row["date"])
  		weekday = date.strftime("%A")
  		if 
  			sortedEvents[weekday].push(row)
  		else
  			sortedEvents[weekday] = [row]
  		end

  end

end