RSpec.describe(Event,"#info") do 

	it "gets the event information associated with the id" do
		
		# Setup
		mockEvent = [['id', 'group', 'title', 'date', 'time', 'location', 'address', 'link'],
		['4', 'test group', 'testing functions', '02-02-2017', "11:00pm", 'Alley way', 
		'88873', 'http://.com']]

		DatabaseHelper.addRows('events', mockEvent)
		event = Event.new("4")

		# Excercise
		result = event.info

		#Verify
		expect(result.values).to eq(mockEvent[1])

		# Teardown
		DatabaseHelper.empty('events')

	end

end

RSpec.describe(Event, "#addAttendee") do
	
	it "adds a new attendee to an event" do

		# Setup
		event = Event.new("9")

		# Excercise
		event.addAttendee("Dan Gheesling")
		csvFirstRow = CSV.read($database.table_path('rsvps'))[0]

		# Verify
		expect(csvFirstRow).to include("Dan Gheesling")		

		# Teardown
		DatabaseHelper.empty("rsvps")

	end

	it "stores the correct events id with the new rsvper" do

		# Setup
		event = Event.new("25")

		# Excercise
		event.addAttendee("Bugs Bunny")
		csvFirstRow = CSV.read($database.table_path('rsvps'))[0]

		# Verify
		expect(csvFirstRow).to include("25")

		# Teardown
		DatabaseHelper.empty('rsvps')

	end

end

RSpec.describe(Event, ".create") do

	it "adds a new event to an empty database" do

		# Setup
		eventDetails = {:'group' => 'test', :'title' => 'test', 
		:'date' => 'test', :'time' => '10:00pm', :'location' => 'test', 
		:'address' => 'test'}

		# Excercise
		Event.create(eventDetails)
		csvFirstRow = CSV.read($database.table_path('events'))[0]

		# Verify
		expect(csvFirstRow.length).to be_truthy

		# Teardown
		DatabaseHelper.empty('events')

	end

	it "saves the information of the event" do

		# Setup
		eventDetails = {:'group' => 'Panda Express pandas', :'title' => 'Orange Chicken', 
		:'date' => '12-01-2016', :'time' => '4:00pm', :'location' => 'panda express', 
		:'address' => 's72nd st'}

		# Excersize

		Event.create(eventDetails)
		csvFirstRow = CSV.read($database.table_path('events'))[0]

		# Verify
		expect(csvFirstRow).to include(eventDetails.values)

		# Teardown
		DatabaseHelper.empty('events')

	end

end
