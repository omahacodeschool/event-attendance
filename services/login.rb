class Login

  # Validate a username and password.
  # 
  # username - String username.
  # password - String password.
  # 
  # Returns Hash of user's information, or Nil.
  def Login.valid(username, password)
    userArr = Database.all_with_filter("users") do |row|
      (row["username"] == username) && (row["password"] == password)
    end

    return userArr[0]
  end

end