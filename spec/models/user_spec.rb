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
		CSV.open($database.table_path('users'), 'w') do |csv|
			csv = ''
		end

	end

	it "adds the new user to the database" do

		# Setup
		email = "bat@man.com"
		pass = "Bruce"
		fullname = "Bruce Wayne"

		# Excercise
		newUser = User.create(email, pass, fullname)
		csvFirstRow = CSV.read($database.table_path('users'))[0]

		# Verify
		expect(csvFirstRow).to include(fullname)

		# Teardown
		DatabaseHelper.empty('users')

	end

end