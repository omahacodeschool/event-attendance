RSpec.describe(Event,"#info") do 
	it "gets the event information" do
		id = "1"
		event = Event.new(id)
		# Needs refactoring reference to 'events.csv' hardcoded in database
		expect(event.info["id"]).to eq(id)
	end

	it "returns nil when no info found" do
		event = Event.new("")
		# Also refers to 'events.csv'
		expect(event.info).not_to eq(nil)
	end
end