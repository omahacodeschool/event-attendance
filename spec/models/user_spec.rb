# RSpec.describe( User, '.create') do 

# 	it "returns a Hash with the newly created user's info" do 

# 		# Setup
# 		email = "foobar@foo.com"
# 		pass = "banana"
# 		fullname = "Mr. Kiwi"

# 		# Excersize
# 		newUser = User.create(email, pass, fullname)

# 		# Verify
# 		expect(newUser).to eq({"username"=>email,"fullname"=>fullname, "admin" => "false"})

# 		# Teardown
# 		CSV.open($database.table_path('users'), 'w') do |csv|
# 			csv = ''
# 		end

# 	end

# 	# it "adds the new user to the database" do
# 	# end

# end