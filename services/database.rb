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

  # Gets a single row from a table with an id.
  #
  # table - Table name string.
  #
  # Returns a csv::row or an error hash.
  def getRowById(table, id)
    CSV.foreach("#{table}.csv", {headers: true, return_headers:false}) do |row|
      if row["id"] == id
        return row
      end
    end
    return {"title" => "not found"}
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


