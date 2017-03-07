# To install Postgres and the Ruby Postgres adapter:

# brew install postgresql
# gem install pg -- --with-pg-config=/usr/local/bin/pg_config

# -----------------------------------------------------------------------------

require "pg"

# When you need to set up the database, just UNCOMMENT the below.
# Remember to comment it back out when you're done.

conn = PG.connect( dbname: 'postgres' )
conn.exec("CREATE DATABASE event_attendance_development")
conn.exec("CREATE DATABASE event_attendance_test")

conn = PG.connect( dbname: 'event_attendance_development' )

# And create tables...