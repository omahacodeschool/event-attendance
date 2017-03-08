RSpec.describe(Database, '#all') do
	
	it 'returns 0 rows for an empty table' do

		# Setup
		DatabaseHelper.empty("events")

		# Excersize
		list = $database.all("events")

		# Verify
		expect(list.length).to eq(0)

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



	it 'returns something from a table that responds to the each method' do
		
		# Setup
		testsql = ["'thing'", "'thing2'"]
		DatabaseHelper.addRows('events', testsql)

		# Excercise
		list = $database.all("events")

		# Verify
		expect(list).to respond_to(:each)

		# Teardown
		DatabaseHelper.empty('events')

	end

end

RSpec.describe( Database, '#next_id') do 

	it "finds and return the number of lines in the csv" do

		# TODO change testcsv to testsql

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

