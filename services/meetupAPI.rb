class MeetupEvents
	def initialize
		@meetups = $database.all("meetups")
		@allMeetupEvents = collectAllEvents
		Event.createMeetups(@allMeetupEvents)	
	end

	def collectAllEvents
		allMeetupEvents = []
			@meetups.each do |row|
				url = row["url"]
				uri = URI('https://api.meetup.com/' + url + '/events')
				stringresult = Net::HTTP.get(uri) # => String
				jsonresult = JSON.parse(stringresult)
				jsonresult.each do |event|
					eventInfo = collectEventInfo(event)
					allMeetupEvents.push(eventInfo)
				end
		end
		return allMeetupEvents
	end

	def collectEventInfo(event)
		date = setDate(event)
		venue = setVenue(event)
		link = setLink(event)
		eventInfo = {
			"groupName" => event["group"]["name"], "eventTitle" => event["name"],
			"date" => date["date"], "time" => date["time"],
			"venue" => venue["venue"], "address" => venue["address"],
			"link" => link, "id" => event["id"],
			"description" => event["description"]
		}
	end

	def setLink(event)
		return "https://www.meetup.com/" + event["group"]["urlname"]
	end

	def setDate(event)
		d = DateTime.strptime(event["time"].to_s,"%Q").new_offset('-06:00')
		time = d.strftime('%I:%M %p')
		date = d.strftime('%F')
		return {"date" => date, "time" => time}
	end

	def setVenue(event)
		venueCheck = event["venue"]
		if venueCheck == nil
			venue = "TBA"
			address = ""
		else
			venue = event["venue"]["name"]
			address = event["venue"]["address_1"]
		end
		return {"venue" => venue, "address" => address}
	end
end