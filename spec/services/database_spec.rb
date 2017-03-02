RSpec.describe(Database, '.all') do
	it 'gets all rows from a table' do
		database = Database.new
	
		list = database.all("spec/fakeEvents")
			binding.pry
			# Maybe second test expecting list.class == Array?
		expect(list.length).to eq(5)
	end

end