# Needs to be run to populat meetup table
# Meetup table is used when accessing the meetup API
# Only events from the meetup groups listed here will be added to the database

Meetups = [
	"coffeeandcode",
	"witheartland",
	"GDGOmaha",
	"1MCNebraska",
	"Omaha-Ruby-Meetup",
	"wine-and-code",
	"Side-Projects-Club",
	"nebraskajs",
	"Nebraska-AI-DATA-Meetup",
	"StartupCollaborative",
	"omaha-emerging-developers",
	"WP-Omaha",
	"Omaha-Mobile-Group",
	"NGDA-Omaha"
]

if ENV['DATABASE_URL']
  uri = URI.parse(ENV['DATABASE_URL'])
  conn = PG.connect(uri.hostname, uri.port, nil, nil, uri.path[1..-1], uri.user, uri.password)
else
  #conn = PG.connect( dbname: 'event_attendance_test' )
  conn = PG.connect( dbname: 'event_attendance_development' )
end

meetups.each do |meetup|
	conn.exec("")
end