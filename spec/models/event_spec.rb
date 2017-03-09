RSpec.describe(Event, '.week') do

	it 'returns an empty hash when there are no events for the week' do
		#set-up
		table = "events"
		dataFiller = "('1','groupName','eventName','2017-02-28','02:00pm','venue','address1','https://www.meetup.com')"
		DatabaseHelper.writeTable(dataFiller,table)
		#exercise
		result = Event.week("2017-03-13")
		#verify
		expect(result).to eq({})
		#teardown
		DatabaseHelper.empty(table)
	end

	it 'returns a hash with weekdays as keys' do
		#set-up
		table = "events"
		dataFiller = "('1','groupName','eventName','2017-02-28','02:00pm','venue','address1','https://www.meetup.com')"
		DatabaseHelper.writeTable(dataFiller,table)
		#exercise
		result = Event.week("2017-02-27")
		#verify
		expect(result["Tuesday"]).to be_truthy
		#teardown
		DatabaseHelper.empty(table)
	end

	it 'returns a hash where values are arrays' do
		#set-up
		table = "events"
		dataFiller = "('1','groupName','eventName','2017-02-28','02:00pm','venue','address1','https://www.meetup.com')"
		DatabaseHelper.writeTable(dataFiller,table)
		#exercise
		result = Event.week("2017-02-27")
		#verify
		expect(result["Tuesday"]).to respond_to :each
		#teardown
		DatabaseHelper.empty(table)
	end

	it 'returns a hash where values are arrays containing event info' do
		#set-up
		table = "events"
		dataFiller = "('1','groupName','eventName','2017-02-28','02:00pm','venue','address1','https://www.meetup.com')"
		DatabaseHelper.writeTable(dataFiller,table)
		#exercise
		result = Event.week("2017-02-27")
		#verify
		expect(result["Tuesday"][0].values).to include("eventName")
		expect(result["Tuesday"][0].keys).to include("link")
		#teardown
		DatabaseHelper.empty(table)
	end

	it 'returns events only for the week of interest' do
		#set-up
		table = "events"
		dataFiller = "('1','groupName','eventName','2017-02-28','02:00pm','venue','address1','https://www.meetup.com'),
			('2','groupName2','eventName2','2017-02-26','02:00pm','venue2','address2','https://www.meetup.com'),
			('3','groupName3','eventName3','2017-03-06','02:00pm','venue3','address3','https://www.meetup.com')"
		DatabaseHelper.writeTable(dataFiller,table)
		#exercise
		result = Event.week("2017-02-27")
		#verify
		expect(result.length).to eq(1)
		expect(result["Tuesday"][0]["id"]).to eq("1")
		#teardown
		DatabaseHelper.empty(table)
	end

	it 'returns events for all days of the week' do
		#set-up
		table = "events"
		dataFiller = "('1','groupName','eventName','2017-02-27','02:00pm','venue','address1','https://www.meetup.com'),
			('2','groupName2','eventName2','2017-02-28','02:00pm','venue2','address2','https://www.meetup.com'),
			('3','groupName3','eventName3','2017-03-01','02:00pm','venue3','address3','https://www.meetup.com'),
			('4','groupName4','eventName4','2017-03-02','02:00pm','venue4','address4','https://www.meetup.com'),
			('5','groupName5','eventName5','2017-03-03','02:00pm','venue5','address5','https://www.meetup.com'),
			('6','groupName6','eventName6','2017-03-04','02:00pm','venue6','address6','https://www.meetup.com'),
			('7','groupName7','eventName7','2017-03-05','02:00pm','venue7','address7','https://www.meetup.com')"
		DatabaseHelper.writeTable(dataFiller,table)
		#exercise
		result = Event.week("2017-02-27")
		#verify
		expect(result.length).to eq(7)
		#teardown
		DatabaseHelper.empty(table)
	end
end

# TODO: Move into meetups_spec.rb
RSpec.describe(Event, '.collectAllEvents') do

	it 'returns an array if there are events' do
		#set-up
		getString = Proc.new do |uri| 
			File.open('spec/support/fake_meetupAPIresult.txt', 'r') { |file| file.read} 
		end
		meetups = ["url"=>"test"]
		#exercise
		result = Event.collectAllEvents(meetups,getString)
		#verify
		expect(result).to respond_to :each
		#teardown	
	end

	it 'returns an array in which each element is a hash of event info' do
		#set-up
		getString = Proc.new do |uri| 
			File.open('spec/support/fake_meetupAPIresult.txt', 'r') { |file| file.read} 
		end
		meetups = ["url"=>"test"]
		#exercise
		result = Event.collectAllEvents(meetups,getString)
		#verify
		expect(result[0]).to respond_to :each
		expect(result[0]["eventTitle"]).to be_truthy
		#teardown
	end

	it 'returns an empty array if no events' do
		#set-up
		getString = Proc.new do |uri| 
			File.open('spec/support/fake_emptymeetupAPIresult.txt', 'r') { |file| file.read} 
		end
		meetups = ["url"=>"test"]
		#exercise
		result = Event.collectAllEvents(meetups,getString)
		#verify
		expect(result).to eq([])
		#teardown
	end
end

RSpec.describe(Event,"#info") do 

	it "gets the event information associated with the id" do
		# Setup
		mockEvent =["'4', 'test group', 'testing functions', '02-02-2017', '11:00pm', 'Alley way', '88873', 'http://.com'"]
		DatabaseHelper.addRows('events', mockEvent)
		event = Event.new("4")
		# Excercise
		result = event.info
		#Verify
		expect(result.values).to include("4" && "test group")
		# Teardown
		DatabaseHelper.empty('events')
	end
end

RSpec.describe(Event, ".create") do

	it "adds a new event to an empty database" do
		# Setup
		eventDetails = {:'group' => 'test', :'title' => 'test', 
		:'date' => '03-08-2017', :'time' => '10:00pm', :'location' => 'test', 
		:'address' => 'test', :'link' => 'http://google.com'}
		# Excercise
		Event.create(eventDetails)
		results = $sql.exec('SELECT * FROM events').to_a
		# Verify
		expect(results).not_to be_empty
		# Teardown
		DatabaseHelper.empty('events')
	end

	it "adds a event into a table with events already existing" do
		# Setup
		$sql.exec("INSERT INTO events VALUES('fake','fake')")
		secondEvent = {:'group' =>'another one', :'title' => 'one', :'date' => '03-08-2017', 
		:'time' => '10:43pm', :'location' => 'please work now', :'address' => '1234 Desperate rd.',
		:'link' => 'google.com/help'}
		# Excercise
		Event.create(secondEvent)
		results = $sql.exec('SELECT * FROM events').to_a.length
		# Verify
		expect(results).to eq(2)
		# Teardown
		DatabaseHelper.empty('events')
	end

	it "saves the information of the event" do
		# Setup
		eventDetails = {:'group' => 'Panda Express pandas', :'title' => 'Orange Chicken', 
		:'date' => '12-01-2016', :'time' => '4:00pm', :'location' => 'panda express', 
		:'address' => 's72nd st', :'link' => 'http://pandaexpress.com'}
		# Excersize
		Event.create(eventDetails)
		results = $sql.exec("SELECT * FROM events").to_a[0]
		# Verify
		expect(results.values).to include(eventDetails[:title])
		# Teardown
		DatabaseHelper.empty('events')
	end
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
