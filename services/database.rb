# TODO Example:
# results = @conn.exec("SELECT * FROM users WHERE admin = 'true'").to_a

class Database

  def initialize(database_name="event_attendance_development")
    @conn = PG.connect( dbname: database_name )
  end

  # Get path to database table.
  # 
  # table - String table name.
  # 
  # Returns String
  def table_path(table)
    table
  end

  # Get all rows from a table.
  # 
  # table - Table name String.
  # 
  # Returns Array of row Hashes.
  def all(table)
    results = @conn.exec("SELECT * FROM #{table}")

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
  # array - an array containing strings
  def newRow(array, table)
    CSV.open(table_path(table), "a") do |csv|
      csv << array
    end
  end

  # deletes a row of information from the given table using a filter
  #
  # table - String
  # Proc with a conditional
  def deleteRow(table, filter)
    csv = CSV.table(table_path(table), headers:true)
    csv.delete_if do |row|
      filter.call(row)
    end
    File.open(table_path(table), 'w') do |row|
      row.write(csv.to_csv)
    end
  end

  # checks if info is already in database
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

  # Sorts based on a column name.
  # 
  # table - String, columnName - String
  # 
  # doesn't return anything but overwrites the csv
  #   with the sorted array or arrays
  def sortContents(table, columnName)
    csv = CSV.read table_path(table)
    csv.sort! { |a, z| a[0].to_i <=> z[0].to_i }
    File.open(table_path(table),'w'){ |f| f << csv.map(&:to_csv).join } 
  end

end



