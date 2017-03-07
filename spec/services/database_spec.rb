
RSpec.describe(Database, "#all_with_filter") do
	it 'gets a specified row' do
		array = [["header1","header2"],["1","test 1"],["2","test 2"]]
		CSV.open($database.table_path("comments"), "wb") do |csv|
			array.each do |row|
     		csv << row
     		end
   		end

   		filter = Proc.new do |row|
     		row["header1"] == "1"
   		end

		list = $database.all_with_filter("comments", filter)
		expect(list).to include("1", "test 1")
	end 

	# TODO Add in this test, or add the assertion to the previous test case.
	# it 'only gets the specified number of rows' do
	# 	array = [["header1","header2"],["1","test 1"],["2","test 2"]]
	# 	CSV.open($database.table_path("comments"), "wb") do |csv|
	# 		array.each do |row|
 #     		csv << row
 #     		end
 #   		end

 #   		filter = Proc.new do |row|
 #     		row["header1"] == "1"
 #   		end

	# 	list = $database.all_with_filter("comments", filter)
	# 	expect(list.length).to eq(1)
	# end 

end 

RSpec.describe(Database, "#checkifUniq") do

	it 'returns a True from database if email exists' do
		array = [["username","password"],["email@a.com","test 1"],["email@b.com","test 2"]]
		CSV.open($database.table_path("users"), "wb") do |csv|
			array.each do |row|
				csv << row
			end
		end

		returnValue = $database.checkifUniq("email@a.com", "users", "username")
		expect(returnValue).to eq(true)
	end 

	it 'returns nil from database if email exists' do
		array = [["username","password"],["email@a.com","test 1"],["email@b.com","test 2"]]
		CSV.open($database.table_path("users"), "wb") do |csv|
			array.each do |row|

RSpec.describe(Database, '#all') do
	
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
		DatabaseHelper.addRows('events', testcsv)

		# Excersize
		list = $database.all("events")

		# Verify
		expect(list.length).to eq(2)

		# Teardown
		DatabaseHelper.empty("events")

	end



	it 'returns something from a table that responds to the each method' do
		
		# Setup
		testcsv = [['thing'], ["thing2"]]
		DatabaseHelper.addRows('events', testcsv)

		# Excercise
		list = $database.all("events")

		# Verify
		expect(list).to respond_to(:each)

		# Teardown
		DatabaseHelper.empty('events')

	end

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
		DatabaseHelper.addRows('events', testcsv)

		# Excersize
		id = $database.next_id('events')

		# Verify
		expect(id).to eq(3)

		# Teardown
		DatabaseHelper.empty('events')

	end

end

