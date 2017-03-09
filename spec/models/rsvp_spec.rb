RSpec.describe(RSVP, '.for_event') do

	pending

end

RSpec.describe(RSVP, '.delete') do

	pending

end

RSpec.describe(RSVP, '.add') do

	pending

end

RSpec.describe(Event, "#addAttendee") do
	
	it "adds a new attendee to an event" do
		# Setup
		event = Event.new("9")
		newRsvp = "Dan Gheesling"

		# Excercise
		event.addAttendee(newRsvp)
		sqlNames = $sql.exec("SELECT fullname FROM rsvps").to_a

		# Verify
		expect(sqlNames.to_s).to include(newRsvp)

		# Teardown
		DatabaseHelper.empty("rsvps")
	end

	it "stores the correct events id with the new rsvper" do
		# Setup
		event = Event.new("25")
		newRsvp = "Bugs Bunny"
		
		# Excercise
		event.addAttendee(newRsvp)
		sqlResult = $sql.exec("SELECT eventid FROM rsvps WHERE fullname='#{newRsvp}'").to_a
		
		# Verify
		expect(sqlResult[0]['eventid']).to eq("25")
		
		# Teardown
		DatabaseHelper.empty('rsvps')
	end
end