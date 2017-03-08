# RSpec.describe(Event,"#createComment") do 

# 	it "checks to see if a new line was written to comments csv" do
# 		# Setup
# 		array = [["commentid","eventid","fullname","comment","timestamp"],["1","1","User 1","Hello World","1488756156"]]
# 		DatabaseHelper.write_to("comments", array)

# 		params = {"comment"=>"Hello World"}
# 		eventId = '1'
# 		fullName = "User 1"

# 		# Exercise
# 		Comment.create(params,fullName,eventId)
# 		lines = DatabaseHelper.lines_in_file("comments")

# 		# Verify
# 		expect(lines).to eq(3) # header + 2 new lines
	
# 		# Teardown
# 		DatabaseHelper.empty("comments")
# 	end

# 	it "checks to see if id of last comment equals '2'" do
# 		# Setup
# 		array = [["commentid","eventid","fullname","comment","timestamp"],["1","1","User 1","Hello World","1488756156"]]
# 		DatabaseHelper.write_to("comments", array)

# 		params = {"comment"=>"Hello World"}
# 		eventId = '1'
# 		fullName = "User 1"

# 		# Exercise
# 		Comment.create(params,fullName,eventId)
# 		lastLine = File.readlines($database.table_path("comments")).last(1)
# 		firstValue = lastLine[0].to_s.chars.first

# 		# Verify
# 		expect(firstValue).to eq("2")
	
# 		# Teardown
# 		DatabaseHelper.empty("comments")
# 	end

# 	it "checks to see if last lines of comments contains proper information" do
# 		# Setup
# 		array = [["commentid","eventid","fullname","comment","timestamp"],["1","1","User 1","Hello World","1488756156"]]
# 		DatabaseHelper.write_to("comments", array)

# 		params = {"comment"=>"Hello Moon"}
# 		eventId = '1'
# 		fullName = "User 2"

# 		# Exercise
# 		Comment.create(params,fullName,eventId)
# 		lastLine = File.readlines($database.table_path("comments")).last(1)
# 		binding.pry

# 		# Verify
# 		expect(lastLine).to contain("User 2", "Hello Moon")
	
# 		# Teardown
# 		DatabaseHelper.empty("comments")
# 	end

# end