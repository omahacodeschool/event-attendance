RSpec.describe(Database, '#all') do
	
	it 'gets all rows from a table' do
		database = Database.new
		list = database.all("spec/fakeEvents")

		expect(list.length).to eq(5)
	end

	it 'returns an array of hashes from a table' do
		database = Database.new
		list = database.all("spec/fakeEvents")

		expect(list.class).to eq(Array)
	end

end