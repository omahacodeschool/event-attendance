# TODO Example:
# results = @conn.exec("SELECT * FROM users WHERE admin = 'true'").to_a

class Database

  def initialize(database_name="event_attendance_development")
    if ENV['DATABASE_URL']
      uri = URI.parse(ENV['DATABASE_URL'])
      @conn = PG.connect(uri.hostname, uri.port, nil, nil, uri.path[1..-1], uri.user, uri.password)
    else
      @conn = PG.connect( dbname: database_name )
    end
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
  # Returns Array of Hashes
  def all_with_filter(table, filter)
    return @conn.exec("SELECT * FROM #{table} WHERE #{filter}").to_a
  end


  def left_with_condition(values="*", table1, table2, condition, filter)
    return @conn.exec("SELECT #{values} FROM #{table1} LEFT OUTER JOIN #{table2} ON #{condition} WHERE #{filter}").to_a
  end

  # Updates a columns value with a condition.
  #
  # table    - Table name of String.
  # column   - String of columns name.
  # newValue - A new value to be written String.
  # filter   - String to determine a condition.
  def updateRow(table, column, newValue, filter)
    @conn.exec("UPDATE #{table} SET #{column} = '#{newValue}' WHERE #{filter}")
  end

  # Adds a new row to the database
  #
  # array - an array containing strings
  def newRow(table, columns, values)
    values = values.join("','")  
    @conn.exec("INSERT INTO #{table}(#{columns}) VALUES ('#{values}')")

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
  # returns Boolean, true if email exists in database
  def checkExistenceOf(table, column , value)
    if @conn.exec("SELECT * FROM #{table} WHERE #{column}='#{value}'").to_a.length == 0
      return false
    else
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
