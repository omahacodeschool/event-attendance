RSpec.describe(Login, '.valid') do
	
  it "validates correct username and password" do
    login_attempt = Login.valid("admin@gmail.com", "password")
    binding.pry
    expect(login_attempt).to be_truthy
  end

  it "validates incorrect username and password" do
    login_attempt = Login.valid("admin@gmail.com", "wrong")

    expect(login_attempt).to be_falsey
  end

end