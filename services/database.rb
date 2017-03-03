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

  # Adds a new row to the database
  #
  # array - an array containing three strings
  def Database.newRow(array, table, uniqId = nil)
    if uniqId != nil 
      array.insert(0, uniqId)
    end

    CSV.open("#{table}.csv", "a") do |csv|
      csv << array
    end
  end

  # TODO Documentation!
  def Database.checkifUniq(email, table, column)
    CSV.foreach("#{table}.csv", {headers: true, return_headers: false}) do |row|
      if row[column] == email
        return true
      else
        next
      end
    end
  end


  private

  # Counts the number of rows in a table
  # 
  # table - string
  # 
  # return Integer
  def Database.next_id(table)
    csv = File.open("#{table}.csv", "r")
    uniqId = csv.readlines.size
    csv.close
    return uniqId
  end

  # deletes a users entry given a table, event id and name
  #
  # table - String, Id = Int, username = String
  def Database.deleteRow(table, id, username)
    csv = CSV.table("#{table}.csv", headers:true)

    csv.delete_if do |row|
  
      row[:eventid] == id.to_i && row[:fullname] == username
    end

    File.open("#{table}.csv", 'w') do |row|
      row.write(csv.to_csv)
    end
  end

end
