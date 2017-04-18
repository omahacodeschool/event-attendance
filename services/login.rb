class Login

  # Validate a username and password.
  # 
  # username - String username.
  # password - String password.
  # 
  # Returns Hash of user's information, or Nil.
  def Login.valid(username, password)
    filter = "username = '#{username}'"
    userArr = $database.all_with_filter("users", filter)
    hashed_password = BCrypt::Password.new(userArr[0]["password"])
    if hashed_password == password
      return userArr[0]
    else
      return nil
    end
  end
end