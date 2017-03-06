class Login

  # Validate a username and password.
  # 
  # username - String username.
  # password - String password.
  # 
  # Returns Hash of user's information, or Nil.
  def Login.valid(username, password)

    filter = Proc.new do |row|
      (row["username"] == username) && (row["password"] == password)
    end

    userArr = $database.all_with_filter("users", filter)
    return userArr[0]
  end

end