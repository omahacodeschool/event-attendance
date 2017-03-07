RSpec.describe(Login, '.valid') do

	it "validates correct username and password" do
  	#set-up
		table = "users"
		csvFiller=[["username","password","fullname","admin"],["admin@gmail.com","password","admin","true"]]
		DatabaseHelper.writeCsv(csvFiller,table)
	#exercise
    	login_attempt = Login.valid("admin@gmail.com", "password")
	#verify
    	expect(login_attempt).to be_truthy
	#teardown
		DatabaseHelper.empty(table)
	end

  it "validates incorrect username and password" do
    #set-up
		table = "users"
		csvFiller=[["username","password","fullname","admin"],["admin@gmail.com","password","admin","true"]]
		DatabaseHelper.writeCsv(csvFiller,table)
	#exercise
    	login_attempt = Login.valid("admin@gmail.com", "wrong")
	#verify
    	expect(login_attempt).to be_falsey
	#teardown
		DatabaseHelper.empty(table)
  end
  
end