class Database
  def all_events
    eventList = []
    CSV.foreach("events.csv", {headers: true, return_headers: false}) do |row|
      eventList.push(row.to_hash)
    end
    jsonEventList = eventList.to_json
    return jsonEventList
  end
end