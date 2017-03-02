RSpec.describe(Database, '.all') do
	it 'gets all rows from a table' do
		database = Database.new 
		list = database.all("events")
		# Refactor to expect list to equal the csv's length
		expect(list.class).to eq(Array)
	end

end