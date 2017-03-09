def stub_meetup_response
  # Stub/Mock
  expect(Meetup).to receive(:response).with(any_args) do
    fake_api_response = 'spec/support/fake_meetupAPIresult.txt'
    File.open(fake_api_response, 'r') { |file| file.read }
  end
end

RSpec.describe Meetup, '.events' do
  it "gets events for Coffee & Code" do
    # Setup
    stub_meetup_response

    # Exercise
    events = Meetup.events("coffeeandcode")

    # Verify
    expect(events[0]).to be_a(Meetup)
  end
end

RSpec.describe Meetup, '#title' do
  it "returns the event's title" do
    # Setup
    stub_meetup_response
    events = Meetup.events("coffeeandcode")
    event = events[0]

    # Exercise/Verify
    expect(event.title).to eq("How is Omaha is progressing on gender equality, diversity, and inclusion in tech")
  end
end

RSpec.describe Meetup, '#date' do
  it "returns the event's date" do
    # Setup
    stub_meetup_response
    events = Meetup.events("coffeeandcode")
    event = events[0]

    # Exercise/Verify
    expect(event.date).to eq("How is Omaha is progressing on gender equality, diversity, and inclusion in tech")
  end
end

RSpec.describe Meetup, '#group_name' do
  it "returns the event's group_name" do
    # Setup
    stub_meetup_response
    events = Meetup.events("coffeeandcode")
    event = events[0]

    # Exercise/Verify
    expect(event.group_name).to eq("How is Omaha is progressing on gender equality, diversity, and inclusion in tech")
  end
end

RSpec.describe Meetup, '#id' do
  it "returns the event's id" do
    # Setup
    stub_meetup_response
    events = Meetup.events("coffeeandcode")
    event = events[0]

    # Exercise/Verify
    expect(event.id).to eq("How is Omaha is progressing on gender equality, diversity, and inclusion in tech")
  end
end

RSpec.describe Meetup, '#time' do
  it "returns the event's time" do
    # Setup
    stub_meetup_response
    events = Meetup.events("coffeeandcode")
    event = events[0]

    # Exercise/Verify
    expect(event.time).to eq("How is Omaha is progressing on gender equality, diversity, and inclusion in tech")
  end
end

RSpec.describe Meetup, '#location' do
  it "returns the event's location" do
    # Setup
    stub_meetup_response
    events = Meetup.events("coffeeandcode")
    event = events[0]

    # Exercise/Verify
    expect(event.location).to eq("How is Omaha is progressing on gender equality, diversity, and inclusion in tech")
  end
end

RSpec.describe Meetup, '#address' do
  it "returns the event's address" do
    # Setup
    stub_meetup_response
    events = Meetup.events("coffeeandcode")
    event = events[0]

    # Exercise/Verify
    expect(event.address).to eq("How is Omaha is progressing on gender equality, diversity, and inclusion in tech")
  end
end

RSpec.describe Meetup, '#link' do
  it "returns the event's link" do
    # Setup
    stub_meetup_response
    events = Meetup.events("coffeeandcode")
    event = events[0]

    # Exercise/Verify
    expect(event.link).to eq("How is Omaha is progressing on gender equality, diversity, and inclusion in tech")
  end
end