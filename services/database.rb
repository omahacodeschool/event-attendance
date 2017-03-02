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

  # Get all rows from a table, given some filter.
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
  end

  # TODO Use all_with_filter instead. This method should be removed.
  def getUsers(id)
    list = []

    # Loops through users.csv and gets all with specific id
    #
    # id = string
    #
    # returns a hash of users
    CSV.foreach("users.csv", {headers: true, return_headers: false}) do |row|
     
      if  row["eventId"] == id
        list.push(row.to_hash)
      end
    end
    return list
  end

  # Appends a new line to events.csv file
  #
  # info - hash of new event strings
  def Database.newEvent(info)
    csv = File.open("events.csv", "a+")
    uniqId = csv.readlines.size

    info.insert(0, uniqId)
    info = info.join(",")
  
    csv.puts info
    csv.close
  end 

  # Adds a new row to the database
  #
  # array - an array containing three strings
  def Database.newRow(array, table)
    # TODO Use Database.next_id to integrate Allen's method's functionality
    #      into this method, thus letting you refactor away Database.newEvent.

    CSV.open(table, "a") do |csv|
      csv << array
    end
  end

  private

  def Database.next_id(table)
    # TODO
  end

end

