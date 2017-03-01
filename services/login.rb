class Login

  LOGINS = {"admin" => "password", "allen" => "duck"}

  # Validate a username and password.
  # 
  # username - String username.
  # password - String password.
  # 
  # Returns Boolean.
  def Login.valid(username, password)
    LOGINS[username] == password
  end

end