# RSpec.describe(Event,"#info") do 

# 	it "gets the event information associated with the id" do
		
# 		# Setup
# 		mockEvent =["'4', 'test group', 'testing functions', '02-02-2017', '11:00pm', 'Alley way', '88873', 'http://.com'"]
# 		DatabaseHelper.addRows('events', mockEvent)
# 		event = Event.new("4")

# 		# Excercise
# 		result = event.info


# 		#Verify
# 		expect(result.values).to include("4" && "test group")

# 		# Teardown
# 		DatabaseHelper.empty('events')

# 	end

# end

# RSpec.describe(Event, "#addAttendee") do
	
# 	it "adds a new attendee to an event" do

# 		# Setup
# 		event = Event.new("9")
# 		newRsvp = "Dan Gheesling"

# 		# Excercise
# 		event.addAttendee(newRsvp)
# 		sqlNames = $sql.exec("SELECT fullname FROM rsvps").to_a

# 		# Verify
# 		expect(sqlNames.to_s).to include(newRsvp)		

# 		# Teardown
# 		DatabaseHelper.empty("rsvps")

# 	end

# 	it "stores the correct events id with the new rsvper" do

# 		# Setup
# 		event = Event.new("25")
# 		newRsvp = "Bugs Bunny"

# 		# Excercise
# 		event.addAttendee(newRsvp)
# 		sqlResult = $sql.exec("SELECT eventid FROM rsvps WHERE fullname='#{newRsvp}'").to_a

# 		# Verify
# 		expect(sqlResult[0]['eventid']).to eq("25")

# 		# Teardown
# 		DatabaseHelper.empty('rsvps')

# 	end

# end

# RSpec.describe(Event, ".create") do

# 	it "adds a new event to an empty database" do

# 		# Setup
# 		eventDetails = {:'group' => 'test', :'title' => 'test', 
# 		:'date' => '03-08-2017', :'time' => '10:00pm', :'location' => 'test', 
# 		:'address' => 'test', :'link' => 'http://google.com'}

# 		# Excercise
# 		Event.create(eventDetails)


# 		# Verify
# 		expect(csvFirstRow.length).to be_truthy

# 		# Teardown
# 		DatabaseHelper.empty('events')

# 	end

# # 	it "saves the information of the event" do

# # 		# Setup
# # 		eventDetails = {:'group' => 'Panda Express pandas', :'title' => 'Orange Chicken', 
# # 		:'date' => '12-01-2016', :'time' => '4:00pm', :'location' => 'panda express', 
# # 		:'address' => 's72nd st'}

# # 		# Excersize

# # 		Event.create(eventDetails)
# # 		csvFirstRow = CSV.read($database.table_path('events'))[0]

# # 		# Verify
# # 		expect(csvFirstRow).to include(eventDetails.values)

# # 		# Teardown
# # 		DatabaseHelper.empty('events')

# # 	end

# end
