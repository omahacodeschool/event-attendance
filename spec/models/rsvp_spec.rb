RSpec.describe(RSVP, '.for_event') do

	it "returns an array" do
		# Setup
	  	DatabaseHelper.writeToTable("rsvps", "('9','Mickey Mouse')","(eventid,fullname)")

		# Exercise
		result = RSVP.for_event('9')
		
		# Verify
		expect(result).to respond_to :each

		# Teardown
		DatabaseHelper.empty("rsvps")
	end

	it "returns an array of hashes with fullnames" do
		# Setup
		DatabaseHelper.writeToTable("rsvps", "('9','Mickey Mouse')","(eventid,fullname)")

		# Exercise
		result = RSVP.for_event('9')
		
		# Verify
		expect(result[0]).to eq({'eventid' => '9','fullname' => 'Mickey Mouse'})

		# Teardown
		DatabaseHelper.empty("rsvps")
	end

	it "returns all rsvps for an eventId" do
		# Setup
		values = "('9', 'Mickey Mouse'), ('9', 'Minnie Mouse')"
	  	DatabaseHelper.writeToTable("rsvps", values, "(eventid,fullname)")
		
		# Exercise
		result = RSVP.for_event('9')
		
		# Verify
		expect(result.length).to eq(2)

		# Teardown
		DatabaseHelper.empty("rsvps")
	end

	it "returns only rsvps for the eventId specified" do
		# Setup
		values = "('9', 'Mickey Mouse'), ('10', 'Minnie Mouse')"
	  	DatabaseHelper.writeToTable("rsvps", values, "(eventid,fullname)")
		
		# Exercise
		result = RSVP.for_event('9')
		
		# Verify
		expect(result.length).to eq(1)

		# Teardown
		DatabaseHelper.empty("rsvps")
	end

end


RSpec.describe(RSVP, ".delete") do
	
	it "deletes an attendee from an event" do
		# Setup
	  	DatabaseHelper.writeToTable("rsvps", "('9','Mickey Mouse')","(eventid,fullname)")

		# Exercise
		RSVP.delete('9','Mickey Mouse')
		
		# Verify
		sqlNames = $sql.exec("SELECT fullname FROM rsvps").to_a
		expect(sqlNames.to_s).not_to include('Mickey Mouse')

		# Teardown
		DatabaseHelper.empty("rsvps")
	end

	it "does not delete other attendees from an event" do
		# Setup
		values = "('9', 'Mickey Mouse'), ('9', 'Minnie Mouse')"
	  	DatabaseHelper.writeToTable("rsvps", values, "(eventid,fullname)")

		# Exercise
		RSVP.delete('9', 'Mickey Mouse')
		
		# Verify
		sqlNames = $sql.exec("SELECT fullname FROM rsvps").to_a
		expect(sqlNames.to_s).to include('Minnie Mouse')

		# Teardown
		DatabaseHelper.empty("rsvps")
	end

	it "does not delete rsvps to other events for the attendee" do
		# Setup
		values = "('9', 'Mickey Mouse'), ('10', 'Mickey Mouse')"
	  	DatabaseHelper.writeToTable("rsvps", values, "(eventid,fullname)")

		# Exercise
		RSVP.delete('9', 'Mickey Mouse')
		
		# Verify
		sqlNames = $sql.exec("SELECT eventid FROM rsvps").to_a
		expect(sqlNames.to_s).to include('10')

		# Teardown
		DatabaseHelper.empty("rsvps")
	end

end

RSpec.describe(RSVP, ".add") do
	
	it "adds a new attendee to an event" do
		# Setup
		eventId = "9"
		newRsvp = "Dan Gheesling"

		# Exercise
		RSVP.add(eventId,newRsvp)
		
		# Verify
		sqlNames = $sql.exec("SELECT fullname FROM rsvps").to_a
		expect(sqlNames.to_s).to include(newRsvp)

		# Teardown
		DatabaseHelper.empty("rsvps")
	end

	it "stores the correct events id with the new rsvper" do
		# Setup
		eventId = "9"
		newRsvp = "Dan Gheesling"

		# Exercise
		RSVP.add(eventId,newRsvp)
		
		# Verify
		sqlResult = $sql.exec("SELECT * FROM rsvps WHERE fullname='#{newRsvp}'").to_a
		expect(sqlResult[0]['eventid']).to eq(eventId)
		
		# Teardown
		DatabaseHelper.empty('rsvps')
	end
end