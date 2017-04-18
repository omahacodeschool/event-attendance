class User

  def initialize(username)
    @user = username
  end

  def validate(fullname, password)
    if (githubInfo and isUnique) then
      register_user(password, fullname)
    else
      return false
    end
  end

  def isUnique
    $database.checkExistenceOf("users", "username", @user)==false
  end

  def response
    uri = URI('https://api.github.com/users/' + @user)
    Net::HTTP.get(uri)  
  end
 
  def info
    response_as_array = JSON.parse(response)
  end

  def githubInfo
    @image = info["avatar_url"]
  end

  def register_user(password, fullname, admin="false")
    columns = "username, password, fullname, admin, image"
    hashed_password = BCrypt::Password.create(password)
    $database.newRow("users", columns, [@user, hashed_password, fullname, admin, @image])  
    return {"username" =>@user, "admin" => admin, "image" => @image}    
  end
end

