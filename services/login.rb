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

  def Login.Uservalid(username, password)
    return Database.checkLogin(username, password)
  end

  def Login.saveLogins(email,pass,fullname)
    if !Database.checkifUniq(email, "logins", "username")
      loginInfo = Array.new([email,pass,fullname])
      Database.newRow(loginInfo, "logins")
    end
  end


end