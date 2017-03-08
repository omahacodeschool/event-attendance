RSpec.describe(Meetups, '.collectAllEvents') do

	it 'returns an array if there are events' do
	#set-up
		getString = Proc.new do |uri| 
			File.open('spec/support/fake_meetupAPIresult.txt', 'r') { |file| file.read} 
		end
		meetups = Meetups.new
	#exercise
		result = meetups.collectAllEvents(getString)
	#verify
		expect(result).to respond_to :each
	#teardown	
	end

	it 'returns an array in which each element is a hash of event info' do
	#set-up
		getString = Proc.new do |uri| 
			File.open('spec/support/fake_meetupAPIresult.txt', 'r') { |file| file.read} 
		end
		meetups = Meetups.new
	#exercise
		result = meetups.collectAllEvents(getString)
	#verify
		expect(result[0]).to respond_to :each
		expect(result[0]["eventTitle"]).to be_truthy
	#teardown
	end

	it 'returns an empty array if no events' do
	#set-up
		getString = Proc.new do |uri| 
			File.open('spec/support/fake_emptymeetupAPIresult.txt', 'r') { |file| file.read} 
		end
		meetups = Meetups.new
	#exercise
		result = meetups.collectAllEvents(getString)
	#verify
		expect(result).to eq([])
	#teardown
	end

end

RSpec.describe(Event, '.addToEvents') do


end