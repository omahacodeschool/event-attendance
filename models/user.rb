class User

  # Create a new user.
  # 
  # params - Hash of user info.
  # 
  # Returns user info as a Hash.
  def User.create(email, pass, fullname, admin="false")

    # if email is not in database - then adds new user row
    if $database.checkExistenceOf("users", "username", email)

      userInfo = [email, pass, fullname, admin]
      $database.newRow("users", "username, password, fullname, admin", userInfo)

      return {"username" => email, "fullname" => fullname, "admin" => admin}
    end
  end
end