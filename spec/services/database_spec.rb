RSpec.describe(Database, '#all') do

	it 'returns 0 for an empty table' do
		# Setup
		DatabaseHelper.empty("events")

		# Excersize
		list = $database.all("events")

		# Verify
		expect(list.length).to eq(0)
	end

	it 'returns an array from a table' do
		# Setup
		testsql = ["'thing'", "'thing2'"]
		DatabaseHelper.addRows("events", testsql)

		# Exercise
		list = $database.all("events")

		# Verify
		expect(list).to respond_to(:each)

		# Teardown
		DatabaseHelper.empty("events")
	end

	it 'returns correct number of rows for a non-empty table' do
		
		# Setup
		testsql = ["'line', 'cell'", "'line', 'cell'"]
		DatabaseHelper.addRows('events', testsql)

		# Excersize
		list = $database.all("events")

		# Verify
		expect(list.length).to eq(2)

		# Teardown
		DatabaseHelper.empty("events")
	end
end

RSpec.describe(Database, "#all_with_filter") do
	it 'gets a specified row' do

		# Setup
		DatabaseHelper.empty("comments")
		array = ["'Person 1','comment 1'","'Person 2','comment 2'"]
		DatabaseHelper.add_row_with_attributes("comments", "fullname, comment", array)

		# Exercise
   	filter = "fullname = 'Person 1'"
   		
   	# Verify
		list = $database.all_with_filter("comments", filter)
		expect(list[0]).to include("fullname" => "Person 1")

		# TearDown
		DatabaseHelper.empty("comments")
	end 
	
	it 'gets a specified row' do

		# Setup
		DatabaseHelper.empty("comments")
		array = ["'name','comment'","'name','comment'"]
		DatabaseHelper.add_row_with_attributes("comments", "fullname, comment", array)

		# Exercise
   		filter = "id > -1"

   		# Verify
		list = $database.all_with_filter("comments", filter)
		expect(list.length).to eq(2)

		# TearDown
		DatabaseHelper.empty("comments")
	end 
end 

RSpec.describe(Database, '#newRow') do
	
	it 'increases table by 1' do
	#set-up
		table = "events"
		dataFiller = "('info1', 'info2', 'info3', '2017-12-12', '02:00 PM', 'info4', 'info5', 'info6')"
		DatabaseHelper.writeTable(dataFiller,table)
		testRow = ["test1", "test2", "test3", "2017-12-12", "02:00 PM", "test4", "test5", "test6"]
	#exercise
		$database.newRow(testRow,table)
	#verify
		length = $sql.exec("SELECT COUNT(*) FROM #{table}").to_a[0]["count"].to_i
		expect(length).to eq(2)
	#teardown
		DatabaseHelper.empty(table)
	end

	it 'adds a specific line to the end of the csv' do
	#set-up
		table = "events"
		dataFiller = "('info1', 'info2', 'info3', '2017-12-12', '02:00 PM', 'info4', 'info5', 'info6')"
		DatabaseHelper.writeTable(dataFiller,table)
		testRow = ["test1", "test2", "test3", "2017-12-12", "02:00 PM", "test4", "test5", "test6"]
	#exercise
		$database.newRow(testRow,table)
	#verify
		expect($sql.exec("SELECT * FROM #{table} WHERE id='test1'")).to be_truthy
	#teardown
		DatabaseHelper.empty(table)
	end
end

RSpec.describe(Database, '#deleteRow') do
	
	it 'length decreases by 1' do
	#set-up
		table = "events"
		dataFiller = "('info1', 'info2', 'info3', '2017-12-12', '02:00 PM', 'info4', 'info5', 'info6'),
						('test1', 'test2', 'test3', '2017-12-12', '02:00 PM', 'test4', 'test5', 'test6')"
		DatabaseHelper.writeTable(dataFiller,table)
		filter = "id = 'info1'"
	#exercise
		$database.deleteRow(table,filter)
	#verify
		length = $sql.exec("SELECT COUNT(*) FROM #{table}").to_a[0]["count"].to_i
		expect(length).to eq(1)
	#teardown
		DatabaseHelper.empty(table)
	end

	it 'removes the line from the file' do
	#set-up
		table = "events"
		dataFiller = "('info1', 'info2', 'info3', '2017-12-12', '02:00 PM', 'info4', 'info5', 'info6'),
						('test1', 'test2', 'test3', '2017-12-12', '02:00 PM', 'test4', 'test5', 'test6')"
		DatabaseHelper.writeTable(dataFiller,table)
		filter = "id = 'info1'"
	#exercise
		$database.deleteRow(table,filter)
	#verify
		expect($sql.exec("SELECT * FROM #{table} WHERE id='info1'").to_a).to be_empty
	#teardown
		DatabaseHelper.empty(table)
	end

end
		
RSpec.describe(Database, '#next_id') do 

	it "finds and returns the number rows" do

		# Setup
		testsql = ["'0'",1,2] 
		DatabaseHelper.addRows('events', testsql)

		# Excersize
		id = $database.next_id('events')

		# Verify
		expect(id).to eq(3)

		# Teardown
		DatabaseHelper.empty('events')

	end

end
