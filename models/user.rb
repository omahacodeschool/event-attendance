class User

  # Create a new user.
  # 
  # params - Hash of user info.
  # 
  # Returns user info as a Hash.
  def User.create(email, pass, fullname, admin="false")
    if $database.checkifUniq(email, "users", "username")
      userInfo = [email, pass, fullname, admin]
      $database.newRow(userInfo, "users")

      return {"username" => email, "fullname" => fullname, "admin" => admin}
    end
  end
end