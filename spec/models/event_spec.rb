RSpec.describe(Event, '.week') do
	
	it 'length increases by 1' do
	#set-up
		table = "events"
		CSV.open($database.table_path(table),'w') do |file|
			file << ["id","group","title","date","time","location","address","link"]
			file << ["test","test2","test3","test","test2","test3","test","test2"]
		end
		array = ["test","test2","test3","test","test2","test3","test","test2"]
	#exercise
		$database.newRow(array,table)
	#verify
		expect(File.open($database.table_path("events"), "r").readlines.size).to eq(3)
	#teardown
		system 'cp databases/events.csv spec/databases/events.csv'
	end

	# pieces to test
	# returns empty hash when there are no events for the week
	# returns hash with weekdays as keys
	# returns hash where value is an array
	# returns hash where value in an array and each element is event info + rsvps
	# does not return events from outside of the week

end
