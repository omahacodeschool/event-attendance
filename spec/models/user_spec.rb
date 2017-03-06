RSpec.describe( User, '.create') do 

	it 'creates a new user' do 

		# Setup
		email = "foobar@foo.com"
		pass = "banana"
		fullname = "Mr. Kiwi"

		# Excersize
		newUser = User.create(email, pass, fullname)

		# Verify
		expect(newUser).to eq({"username"=>email,"fullname"=>fullname, "admin" => "false"})

		# Teardown
		newUser = nil;
		CSV.open($database.table_path('users'), 'w') do |csv|
			csv = ''
		end

	end

end