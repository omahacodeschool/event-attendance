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
