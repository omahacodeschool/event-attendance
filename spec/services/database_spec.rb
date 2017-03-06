RSpec.describe(Database, '#newRow') do
	
	it 'length increases by 1' do
	#set-up
		table = "events"
		CSV.open($database.table_path(table),'w') do |file|
			file << ["id","group","title","date","time","location","address","link"]

			# TODO Make this different from the row you'll be creating, or remove it.
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

		# TODO File.readlines should give you an Array-like object to verify directly.
		line_count = File.readlines($database.table_path(table)).size
		count = 0
		lastrow = []
		CSV.foreach($database.table_path(table)) do |row|
			count += 1
  			if count == line_count then lastrow = row end
  		end
		expect(lastrow).to eq(array)
	#teardown
		system 'cp databases/events.csv spec/databases/events.csv'
	end
end


RSpec.describe(Database, '#deleteRow') do
	
	it 'length decreases by 1' do
	#set-up
		table = "events"
		CSV.open($database.table_path(table),'w') do |file|
			file << ["id","group","title","date","time","location","address","link"]
			file << ["test","test2","test3","test","test2","test3","test","test2"]
		end
		filter = Proc.new do |row|
      		row[:id] == "test"
    	end
	#exercise
		$database.deleteRow(table,filter)
	#verify
		expect(File.open($database.table_path("events"), "r").readlines.size).to eq(1)
	#teardown
		system 'cp databases/events.csv spec/databases/events.csv'
	end

	it 'last line is no longer in file' do
	#set-up
		table = "events"
		array = ["test","test2","test3","test","test2","test3","test","test2"]
		CSV.open($database.table_path(table),'w') do |file|
			file << ["id","group","title","date","time","location","address","link"]
			file << array
		end
		filter = Proc.new do |row|
      		row[:id] == "test"
    	end
	#exercise
		$database.deleteRow(table,filter)
	#verify
		line_count = File.readlines($database.table_path(table)).size
		count = 0
		lastrow = []
		CSV.foreach($database.table_path(table)) do |row|
			count += 1
  			if count == line_count then lastrow = row end
  		end
		expect(lastrow).not_to eq(array)
	#teardown
		system 'cp databases/events.csv spec/databases/events.csv'

end

RSpec.describe( Database, '#all') do 

	it 'returns 0 for an empty table' do

		# Setup
		DatabaseHelper.empty("events")

		# Excersize
		list = $database.all("events")

		# Verify
		expect(list.length).to eq(0)

	end

	it 'returns correct value for a non-empty table' do
		
		# Setup
		testcsv = [["header1", "header2"], ["line", "cell"], ["line", "cell"]]
		CSV.open($database.table_path('events'), 'w') do |csv|
			testcsv.each do |row|
				csv << row
			end
		end

		# Excersize
		list = $database.all("events")

		# Verify
		expect(list.length).to eq(2)

		# Teardown
		DatabaseHelper.empty("events")

	end



	it 'returns an array from a table' do
		
		list = $database.all("events")

		expect(list.class).to eq(Array)
		# expect(list).to respond_to(:each)
	end

	# TODO - Consider testing the innards of $database.all.
	# 
	# it 'returns an array of hashes from a table' do
		
	# 	list = $database.all("events")

	# 	expect(list.first.class).to eq(Hash)
	# end

end





RSpec.describe( Database, '#table_path') do

	it "Gets the path to databases" do

		# Setup
		testDatabase = Database.new("panda")

		# Excersize
		path = testDatabase.table_path("pie")

		# Verify
		expect(path).to eq("panda/pie.csv")

	end

end



RSpec.describe( Database, '#next_id') do 

	it "finds and return the number of lines in the csv" do

		# Setup
		testcsv = [["number"],[1],[2]] 
		CSV.open($database.table_path('events'), 'w') do |csv|
			testcsv.each do |row|
				csv << row
			end
		end

		# Excersize
		id = $database.next_id('events')

		# Verify
		expect(id).to eq(3)

		# Teardown
		CSV.open($database.table_path('events'), 'w') do |csv|
			csv = ""
		end
	end

end


















