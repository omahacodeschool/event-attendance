def stub_meetup_response
  # Stub/Mock
  expect(Meetup).to receive(:response).with(any_args) do
    fake_api_response = 'spec/support/fake_meetupAPIresult.txt'
    File.open(fake_api_response, 'r') { |file| file.read }
  end
end

RSpec.describe Meetup, '.events' do

  it "gets events for Women in Technology of the Heartland" do
    # Setup
    stub_meetup_response

    # Exercise
    events = Meetup.events("witheartland")

    # Verify
    expect(events[0]).to be_a(Meetup)
  end

  it "deletes the original listing of the meetup, and adds the new one" do
    # Setup
    stub_meetup_response
    meetupEvent ="('238195771', 
      'Women in Technology of the heartland', 
      'How is Omaha is progressing on gender equality, diversity, and inclusion in tech', 
      '2017-03-21', '05:15 PM', 'Do Space', '2120 S 72nd St # 1300', 
      'https://www.meetup.com/witheartland/events/238195771/', 'This event will be about awesome stuff.')"
    DatabaseHelper.writeToTable('events', meetupEvent)

    # Exercise
    events = Meetup.events("witheartland")

    # Verify
    expect($sql.exec("SELECT * FROM events WHERE location='Do Space'").to_a).to be_empty
    expect($sql.exec("SELECT * FROM events WHERE location='Client Resources Inc'").to_a[0].values).to include('238195771')

    #teardown
    DatabaseHelper.empty('events')
  end

end

RSpec.describe Meetup, '#group_name' do
  it "returns the event's group_name" do
    # Setup
    stub_meetup_response
    events = Meetup.events("witheartland")
    event = events[0]

    # Exercise/Verify
    expect(event.group_name).to eq("Women in Technology of the Heartland")
  end
end

RSpec.describe Meetup, '#title' do
  it "returns the event's title" do
    # Setup
    stub_meetup_response
    events = Meetup.events("witheartland")
    event = events[0]

    # Exercise/Verify
    expect(event.title).to eq("How is Omaha is progressing on gender equality, diversity, and inclusion in tech")
  end
end

RSpec.describe Meetup, '#date' do
  it "returns the event's date" do
    # Setup
    stub_meetup_response
    events = Meetup.events("witheartland")
    event = events[0]

    # Exercise/Verify
    expect(event.date).to eq("2017-03-21")
  end
end

RSpec.describe Meetup, '#time' do
  it "returns the event's time" do
    # Setup
    stub_meetup_response
    events = Meetup.events("witheartland")
    event = events[0]

    # Exercise/Verify
    expect(event.time).to eq("05:15 PM")
  end
end

RSpec.describe Meetup, '#location' do
  it "returns the event's location" do
    # Setup
    stub_meetup_response
    events = Meetup.events("witheartland")
    event = events[0]

    # Exercise/Verify
    expect(event.location).to eq("Client Resources Inc")
  end
end

RSpec.describe Meetup, '#address' do
  it "returns the event's address" do
    # Setup
    stub_meetup_response
    events = Meetup.events("witheartland")
    event = events[0]

    # Exercise/Verify
    expect(event.address).to eq("2120 S 72nd St # 1300")
  end
end

RSpec.describe Meetup, '#link' do
  it "returns the event's link" do
    # Setup
    stub_meetup_response
    events = Meetup.events("witheartland")
    event = events[0]

    # Exercise/Verify
    expect(event.link).to eq("https://www.meetup.com/witheartland/events/238195771/")
  end
end

RSpec.describe Meetup, '#description' do
  it "returns the event's description" do
    # Setup
    stub_meetup_response
    events = Meetup.events("witheartland")
    event = events[0]

    # Exercise/Verify
    expect(event.description).to eq("Women in Technology of the Heartland wants the girls, people of color, and other underrepresented groups that Omaha encourages to pursue STEM educations and future tech jobs to have real opportunities to succeed. Research entitled \"Women in the Workplace,\" conducted by LeanIn.")
  end
end