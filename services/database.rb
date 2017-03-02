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

  # Get one week of events.
  # 
  # table  - Table name String.
  # filter - Proc of the filter function to call.
  # 
  # Returns Array of row Hashes in the week of interest
  def all_with_filter(table, filter)
    all_rows = all(table)

    filtered_rows = []

    all_rows.each do |row|
      if filter.call(row)
        filtered_rows.push(row.to_h)
      end
    end

    return filtered_rows
  end


  # Gets a single row from a table with an id.
  #
  # table - Table name string.
  #
  # Returns a csv::row or an error hash.
  def getRowById(table, id)
    CSV.foreach("#{table}.csv", {headers: true, return_headers:false}) do |row|
      if row["id"] == id
        return row.to_h
      end
    end
    return {"title" => "not found"}
  end

  def getUsers(id)
    list = []


    CSV.foreach("users.csv", {headers: true, return_headers: false}) do |row|
     
      if  row["eventId"] == id
        list.push(row.to_hash)
      end
    end
    return list
  end
  
  # Adds a new row to the database
  #
  # array - an array containing three strings
  def Database.newRow(array)
    CSV.open("users.csv", "a") do |csv|
      csv << array
    end
  end

end

