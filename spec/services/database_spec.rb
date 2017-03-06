RSpec.describe(Database, '#newRow') do
	
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

	it 'last line is what was added' do
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

end