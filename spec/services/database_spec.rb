RSpec.describe(Database, '#all') do
	
	it 'returns 0 for an empty table' do
		list = $database.all("events")

		expect(list.length).to eq(5)
	end

  it 'returns correct value for a non-empty table' do
    # Setup
      # Delete all rows.
  end

	it 'returns an array of hashes from a table' do
		list = $database.all("events")

		expect(list.class).to eq(Array)
	end

end