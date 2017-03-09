RSpec.describe( User, '.create') do 

	it "returns a Hash with the newly created user's info" do 
		# Setup
		email = "foobar@foo.com"
		pass = "banana"
		fullname = "Mr. Kiwi"
		# Excersize
		newUser = User.create(email, pass, fullname)
		# Verify
		expect(newUser).to eq({"username"=>email,"fullname"=>fullname, "admin" => "false"})
		# Teardown
		DatabaseHelper.empty('users')
	end

	it "adds the new user to the database" do
		# Setup
		email = "bat@man.com"
		pass = "Bruce"
		fullname = "Bruce Wayne"
		# Excercise
		newUser = User.create(email, pass, fullname)
		sqlFirstRow = $sql.exec("SELECT * FROM users")[0]
		# Verify
		expect(sqlFirstRow.values).to include(fullname && email)
		# Teardown
		DatabaseHelper.empty('users')
	end

	it "doesn't add a user if the email is taken" do
		# Setup
		firstUser = ["'Test@nothing.edu', 'password123', 'Email Thief'"]
		DatabaseHelper.addRows('users', firstUser)
		# Excercise
		newUser = User.create("Test@nothing.edu", "security", "Smart T.")
		numberOfUsers = $sql.exec("SELECT * FROM users").to_a.length
		# Verify
		expect(numberOfUsers).to eq(1)
		# Teardown
		DatabaseHelper.empty('users')
	end
end
