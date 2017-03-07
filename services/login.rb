class Login

  # Validate a username and password.
  # 
  # username - String username.
  # password - String password.
  # 
  # Returns Hash of user's information, or Nil.
  def Login.valid(username, password)
    
    filter = "username = '#{username}' AND password = '#{password}'"

    userArr = $database.all_with_filter("users", filter)
    return userArr[0]
  end

end