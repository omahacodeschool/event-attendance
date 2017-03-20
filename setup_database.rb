# To install Postgres and the Ruby Postgres adapter:

# brew install postgresql
# gem install pg -- --with-pg-config=/usr/local/bin/pg_config

# -----------------------------------------------------------------------------

require "pg"

# # When you need to set up the database, just UNCOMMENT the below.
# # Remember to comment it back out when you're done.

conn = PG.connect( dbname: 'postgres' )

# app_name = "event_attendance"

# conn.exec("CREATE DATABASE #{app_name}_development")
# conn.exec("CREATE DATABASE #{app_name}_test")


#conn = PG.connect( dbname: 'event_attendance_test' )
conn = PG.connect( dbname: 'event_attendance_development' )

# And create tables...
conn.exec("CREATE TABLE events (id VARCHAR(255), group_name VARCHAR(255), title VARCHAR(255), date DATE, time TIME, location VARCHAR(255), address VARCHAR(255), link TEXT)")

conn.exec("CREATE TABLE comments (id SERIAL PRIMARY KEY, eventid VARCHAR(255), username VARCHAR(255), comment TEXT, timestamp INTEGER )")

conn.exec("CREATE TABLE meetups (url VARCHAR(255))")

conn.exec("CREATE TABLE rsvps (eventid VARCHAR(255), username VARCHAR(255))")

conn.exec("CREATE TABLE users (username VARCHAR(255), password VARCHAR(255), fullname VARCHAR(255), admin VARCHAR(255), image TEXT)")



