# TODO Add a single line between each stage of a test (setup, exercise, etc).

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
		testsql = "('thing', 'thing2')"
		DatabaseHelper.writeToTable("events", testsql)

		# Exercise
		list = $database.all("events")

		# Verify
		expect(list).to respond_to(:each)

		# Teardown
		DatabaseHelper.empty("events")
	end

	it 'returns correct number of rows for a non-empty table' do
		# Setup
		testsql = "('line', 'cell'), ('line', 'cell')"
		DatabaseHelper.writeToTable('events', testsql)

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
		fakeRows = "('Person 1','comment 1'), ('Person 2','comment 2')"
		DatabaseHelper.writeToTable("comments",  fakeRows, "(fullname, comment)")
		filter = "fullname = 'Person 1'"

		# Exercise
		list = $database.all_with_filter("comments", filter)

		# Verify
		expect(list[0]).to include("fullname" => "Person 1")

		# TearDown
		DatabaseHelper.empty("comments")
	end 
	
	# TODO Name this test accurately.
	it 'gets multiple rows that match the filter' do
		# Setup
		DatabaseHelper.empty("comments")
		fakeRows = "('Allen', 'My comment.'), ('Allen','Another comment.'), ('Spencer','My thoughts.')"
		DatabaseHelper.writeToTable("comments", fakeRows, "(fullname, comment)")

		# Exercise

		filter = "fullname = 'Allen'"
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
		DatabaseHelper.writeToTable(table,dataFiller)
		testRow = ["test1", "test2", "test3", "2017-12-12", "02:00 PM", "test4", "test5", "test6"]

		#exercise
		$database.newRow(testRow,table)

		#verify
		length = $sql.exec("SELECT COUNT(*) FROM #{table}").to_a[0]["count"].to_i
		expect(length).to eq(2)

		#teardown
		DatabaseHelper.empty(table)
	end

	it 'adds a specific line to the end of the table' do
		#set-up
		table = "events"
		dataFiller = "('info1', 'info2', 'info3', '2017-12-12', '02:00 PM', 'info4', 'info5', 'info6')"
		DatabaseHelper.writeToTable(table,dataFiller)
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
		DatabaseHelper.writeToTable(table,dataFiller)
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
		DatabaseHelper.writeToTable(table,dataFiller)
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
		testsql = "(0),(1),(2)" 
		DatabaseHelper.writeToTable('events', testsql)
		
		# Excersize
		id = $database.next_id('events')
		
		# Verify
		expect(id).to eq(3)
		
		# Teardown
		DatabaseHelper.empty('events')
	end
end

# TODO

RSpec.describe(Database, '#checkExistenceOf') do

	pending

end

RSpec.describe(Database, '#updateRow') do

	pending

end
