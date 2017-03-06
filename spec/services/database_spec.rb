RSpec.describe(Database, '#all') do
	
	# it 'returns 0 for an empty table' do
	# 	pending
	# 	list = $database.all("events")

	# 	expect(list.length).to eq(5)
	# end

 #  it 'returns correct value for a non-empty table' do
 #  	pending
 #    # Setup
 #      # Delete all rows.
 #  end

	# it 'returns an array of hashes from a table' do
	# 	pending
	# 	list = $database.all("events")

	# 	expect(list.class).to eq(Array)
	# end

end

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

	# it 'last line is what was added' do
	# 	pending
	# 	list = $database.all("events")

	# 	expect(list.length).to eq(5)
	# end

end