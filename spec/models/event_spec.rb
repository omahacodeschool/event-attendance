RSpec.describe(Event, '.week') do

	it 'returns an empty hash when there are no events for the week' do
	#set-up
		table = "events"
		csvFiller = [["id","group","title","date","time","location","address","link"],
			["1","groupName","eventName","2017-02-28","02:00pm","venue","address1","https://www.meetup.com"]]
		DatabaseHelper.writeCsv(csvFiller,table)
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
		csvFiller = [["id","group","title","date","time","location","address","link"],
			["1","groupName","eventName","2017-02-28","02:00pm","venue","address1","https://www.meetup.com"]]
		DatabaseHelper.writeCsv(csvFiller,table)
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
		csvFiller = [["id","group","title","date","time","location","address","link"],
			["1","groupName","eventName","2017-02-28","02:00pm","venue","address1","https://www.meetup.com"]]
		DatabaseHelper.writeCsv(csvFiller,table)
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
		csvFiller = [["id","group","title","date","time","location","address","link"],
			["1","groupName","eventName","2017-02-28","02:00pm","venue","address1","https://www.meetup.com"]]
		DatabaseHelper.writeCsv(csvFiller,table)
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
		csvFiller = [["id","group","title","date","time","location","address","link"],
			["1","groupName1","eventName1","2017-02-28","02:00pm","venue1","address1","https://www.meetup.com"],
			["2","groupName2","eventName2","2017-02-26","02:00pm","venue2","address2","https://www.meetup.com"],
			["3","groupName3","eventName3","2017-03-06","02:00pm","venue3","address3","https://www.meetup.com"]]
		DatabaseHelper.writeCsv(csvFiller,table)
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
		csvFiller = [["id","group","title","date","time","location","address","link"],
			["1","groupName1","eventName1","2017-02-27","02:00pm","venue1","address1","https://www.meetup.com"],
			["2","groupName2","eventName2","2017-02-28","02:00pm","venue2","address2","https://www.meetup.com"],
			["3","groupName3","eventName3","2017-03-01","02:00pm","venue3","address3","https://www.meetup.com"],
			["4","groupName1","eventName1","2017-03-02","02:00pm","venue1","address1","https://www.meetup.com"],
			["5","groupName2","eventName2","2017-03-03","02:00pm","venue2","address2","https://www.meetup.com"],
			["6","groupName3","eventName3","2017-03-04","02:00pm","venue3","address3","https://www.meetup.com"],
			["7","groupName3","eventName3","2017-03-05","02:00pm","venue3","address3","https://www.meetup.com"],
		]
		DatabaseHelper.writeCsv(csvFiller,table)
	#exercise
		result = Event.week("2017-02-27")
	#verify
		expect(result.length).to eq(7)
	#teardown
		DatabaseHelper.empty(table)
	end

end



RSpec.describe(Event, '.updateMeetups') do

	it '' do
	#set-up
		# getString = Proc.new do |uri|  end
			system 'pwd'
			string = File.open('spec/support/test.txt', 'r') { |file| file.read }
			binding.pry

	#exercise
		
	#verify
		
	#teardown
		
	end

end










RSpec.describe(Event,"#createComment") do 

	params = {"comment"=>"Hello World", "eventId"=>"1"}
	event = Event.new(params["eventId"])
	event.createComment(params, $database.table_path("comments"))

end

RSpec.describe(Event,"#info") do 
	
	it "gets the event information associated with the id" do
		
		# Setup
		mockEvent = [['id', 'group', 'title', 'date', 'time', 'location', 'address', 'link'],
		['4', 'test group', 'testing functions', '02-02-2017', "11:00pm", 'Alley way', 
		'88873', 'http://.com']]

		CSV.open($database.table_path("events"), 'w') do |csv|
			mockEvent.each do |row|
				csv << row
			end
		end
		
		event = Event.new("4")

		# Excersize
		result = event.info

		#Verify
		expect(result.values).to eq(mockEvent[1])

		# Teardown
		CSV.open($database.table_path("events"), 'w') do |csv|
			csv = ""
		end

	end

end
