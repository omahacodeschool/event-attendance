class Database

  def initialize(database_path="databases")
    @database_path = database_path
  end

  # Get path to database table.
  # 
  # table - String table name.
  # 
  # Returns String
  def table_path(table)
    "#{@database_path}/#{table}.csv"
  end

  # Get all rows from a table.
  # 
  # table - Table name String.
  # 
  # Returns Array of row Hashes.
  def all(table)
    list = []
    CSV.foreach(table_path(table), {headers: true, return_headers: false}) do |row|
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
  # array - an array
  def newRow(array, table, uniqId = nil)
    if uniqId != nil 
      array.insert(0, uniqId)
    end

    CSV.open(table_path(table), "a") do |csv|
      csv << array
    end
  end

  # returns a row from database based on params
  #
  # email - String, table - String, column - String
  #
  # returns Boolean
  def checkifUniq(email, table, column)
    CSV.foreach(table_path(table), {headers: true, return_headers: false}) do |row|
      if row[column] == email
        return true
      else
        next
      end
    end
  end

  # Counts the number of rows in a table
  # 
  # table - string
  # 
  # return Integer
  def next_id(table)
    csv = File.open(table_path(table), "r")
    uniqId = csv.readlines.size
    csv.close
    return uniqId
  end


  # deletes an entry given a table, event id and name
  #
  # table - String, Id = Int, username = String
  def deleteRow(table, id, username)
    csv = CSV.table(table_path(table), headers:true)
    csv.delete_if do |row|
      row[:eventid] == id.to_i && row[:fullname] == username
    end
    File.open(table_path(table), 'w') do |row|
      row.write(csv.to_csv)
    end
  end

  # Deletes a comment based on a comment Id
  # 
  # table - String, Id = String
  def deleteComment(table, id)
    csv = CSV.table(table_path(table), headers:true)
    csv.delete_if do |row|
      row[:commentid] == id.to_i
    end
    File.open(table_path(table), 'w') do |row|
      row.write(csv.to_csv)
    end
  end 

  # Sorts based on a column name.
  # 
  # table - String, columnName - String
  # 
  # doesn't return anything but overwrites the csv
  #   with the sorted hash
  def sortContents(table, columnName)
    rows = []
    CSV.foreach(table_path(table), headers: true) do |row|
      rows << row.to_h
    end
    data = rows.sort_by{ |row| row[columnName] }   
    CSV.open(table_path(table), "wb") do |csv|
      csv << data.first.keys
      data.each do |hash|
        csv << hash.values
      end
    end
  end
end


