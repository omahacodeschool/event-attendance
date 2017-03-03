RSpec.describe(Database, '#all') do
	
	it 'gets all rows from a table' do
		list = $database.all("events")

		expect(list.length).to eq(5)
	end

	it 'returns an array of hashes from a table' do
		list = $database.all("events")

		expect(list.class).to eq(Array)
	end

end