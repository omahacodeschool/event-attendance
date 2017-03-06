RSpec.describe(Event,"#info") do 
	it "gets the event information" do
		id = '1'
		event = Event.new(id)
		expect(event.info["id"]).to eq(id)
	end

end


RSpec.describe(Event,"#createComment") do 

	params = {"comment"=>"Hello World", "eventId"=>"1"}
	event = Event.new(params["eventId"])
	event.createComment(params, $database.table_path("comments"))

end
