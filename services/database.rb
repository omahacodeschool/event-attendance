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
    return @conn.exec("SELECT * FROM #{table}").to_a
  end

  # Get all rows from a table, given some filter.
  # 
  # table  - Table name String.
  # filter - Proc of the filter function to call.
  # 
  # Returns Array of row Hashes in the week of interest
  def all_with_filter(table, filter)
    return @conn.exec("SELECT * FROM #{table} WHERE #{filter}").to_a
  end


  def updateRow(table, column, newValue, filter)
    @conn.exec("UPDATE #{table} SET #{column} = '#{newValue}' WHERE #{filter}")
      # set comment = new-comment WHERE commentid = commentid and fullname = fullname
  end
  # Adds a new row to the database
  #
  # array - an array containing strings
  def newRow(array, table)

    valuesString = array.join("','")  
    binding.pry
    @conn.exec("INSERT INTO #{table} VALUES ('#{valuesString}')")

  end

  # deletes a row of information from the given table using a filter
  #
  # table - String
  # Proc with a conditional
  def deleteRow(table, filter)

     @conn.exec("DELETE FROM #{table} WHERE #{filter}")

  end

  # checks if info is already in database
  #
  # email  - String
  # table  - String
  # column - String
  #
  # returns Boolean, true if unique
  def checkExistenceOf(email, table, column)
    if @conn.exec("SELECT * FROM #{table} WHERE #{column}='#{email}'").to_a.length == 0
      return true
    end
  end

  # Counts the number of rows in a table
  # 
  # table - string
  # 
  # return Integer
  def next_id(table)
    @conn.exec("SELECT COUNT(*) FROM #{table}").to_a[0]["count"].to_i
  end
end
