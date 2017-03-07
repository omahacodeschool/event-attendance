RSpec.describe(Database, '#newRow') do
	
	it 'increases csv by 1' do
	#set-up
		table = "events"
		csvFiller = [["header1","header2"],["info1","info2"]]
		DatabaseHelper.writeCsv(csvFiller,table)
		testRow = ["test","test2"]
	#exercise
		$database.newRow(testRow,table)
	#verify
		expect(File.open($database.table_path("events"), "r").readlines.size).to eq(3)
	#teardown
		DatabaseHelper.empty(table)
	end

	it 'adds a specific line to the end of the csv' do
	#set-up
		table = "events"
		csvFiller = [["header1","header2"],["info1","info2"]]
		DatabaseHelper.writeCsv(csvFiller,table)
		testRow = ["test1","test2"]
	#exercise
		$database.newRow(testRow,table)
	#verify
		lines = File.readlines($database.table_path(table))
		expect(lines[-1]).to include(testRow[0] && testRow[1])
	#teardown
		DatabaseHelper.empty(table)
	end
end


RSpec.describe(Database, '#deleteRow') do
	
	it 'length decreases by 1' do
	#set-up
		table = "events"
		csvFiller = [["header1","header2"],["info1","info2"],["test1","test2"]]
		DatabaseHelper.writeCsv(csvFiller,table)
		filter = Proc.new do |row|
      		row[:header1] == "info1"
    	end
	#exercise
		$database.deleteRow(table,filter)
	#verify
		expect(File.open($database.table_path("events"), "r").readlines.size).to eq(2)
	#teardown
		DatabaseHelper.empty(table)
	end

	it 'last line is no longer in file' do
	#set-up
		table = "events"
		csvFiller = [["header1","header2"],["info1","info2"],["test1","test2"]]
		DatabaseHelper.writeCsv(csvFiller,table)
		filter = Proc.new do |row|
      		row[:header1] == "info1"
    	end
	#exercise
		$database.deleteRow(table,filter)
	#verify
		lines = File.readlines($database.table_path(table))
		expect(lines[-1]).not_to include("info1")
	#teardown
		DatabaseHelper.empty(table)
	end

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


















