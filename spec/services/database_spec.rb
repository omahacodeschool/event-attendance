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

# RSpec.describe(Database, '#all') do
	
# 	it 'returns 0 for an empty table' do

# 		# Setup
# 		DatabaseHelper.empty("events")

# 		# Excersize
# 		list = $database.all("events")

# 		# Verify
# 		expect(list.length).to eq(0)

# 	end



# 	it 'returns correct value for a non-empty table' do
		
# 		# Setup
# 		testcsv = ["'line', 'cell'", "'line', 'cell'"]
# 		DatabaseHelper.addRows('events', testcsv)

# 		# Excersize
# 		list = $database.all("events")

# 		# Verify
# 		expect(list.length).to eq(2)

# 		# Teardown
# 		DatabaseHelper.empty("events")

# 	end



# 	it 'returns something from a table that responds to the each method' do
		
# 		# Setup
# 		testcsv = ["'thing'", "'thing2'"]
# 		DatabaseHelper.addRows('events', testcsv)

# 		# Excercise
# 		list = $database.all("events")

# 		# Verify
# 		expect(list).to respond_to(:each)

# 		# Teardown
# 		DatabaseHelper.empty('events')

# 	end

# end

# RSpec.describe( Database, '#next_id') do 

# 	it "finds and return the number of lines in the csv" do

# 		# TODO change testcsv to testsql

# 		# Setup
# 		testcsv = ["'0'",1,2] 
# 		DatabaseHelper.addRows('events', testcsv)

# 		# Excersize
# 		id = $database.next_id('events')

# 		# Verify
# 		expect(id).to eq(3)

# 		# Teardown
# 		DatabaseHelper.empty('events')

# 	end

# end

