RSpec.describe(Database, '#all') do
	
	it 'returns 0 for an empty table' do

		# Setup
		CSV.open($database.table_path('events'), 'w') do |csv|
				csv = ''
		end

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
		CSV.open($database.table_path('events'), 'w') do |csv|
			csv = ''
		end

	end



	it 'returns an array of hashes from a table' do
		
		list = $database.all("events")

		expect(list.class).to eq(Array)
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

		# Teardown
		testDatabase = nil

	end

end





















