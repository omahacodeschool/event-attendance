class Database

  # Get all rows from a table.
  # 
  # table - Table name String.
  # 
  # Returns Array of row Hashes.
  def all(table)
    list = []
    CSV.foreach("#{table}.csv", {headers: true, return_headers: false}) do |row|
      list.push(row.to_hash)
    end
    return list
  end

  def getUsers(id)
    list = []
    CSV.foreach("users.csv", {headers: true, return_headers: false}) do |row|
      if  row["eventId"].to_i == id
        list.push(row.to_hash)
      end
    end
    return list
  end

end




