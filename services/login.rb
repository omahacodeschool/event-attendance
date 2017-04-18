class Login

  # Validate a username and password.
  # 
  # username - String username.
  # password - String password.
  # 
  # Returns Hash of user's information, or Nil.
  def Login.valid(username, password)
    filter = "username = '#{username.downcase}'"
    userArr = $database.all_with_filter("users", filter)
    if userArr == [] then return nil end
    if BCrypt::Password.new(userArr[0]["password"]) == password
      return userArr[0]
    else
      return nil
    end
  end
end