class DatabaseHelper

  # Empties everything from a table
  #
  # table - table's name as a String
  def DatabaseHelper.empty(table)
    $sql.exec( "DELETE FROM #{table}" )
  end

  # Writes rows to a table
  #
  # table - name of file as String
  # content - String of values to add
  # columns - String used to specify column names
  #
  # Example
  #
  #   DatabaseHelper.writeToTable("events", "('Test group', 'Testing')")
  #   # => "INSERT INTO events VALUES ('Test group', 'Testing')"
  #
  #   DatabaseHelper.writeToTable("events", "('13th st', 'Refactoring')", "(address, title)")
  #   # => "INSERT INTO events (address, title) VALUES ('13th st', 'Refactoring')"
  def DatabaseHelper.writeToTable(table, content,  columns = nil)
    $sql.exec("INSERT INTO #{table} #{columns} VALUES #{content}")
  end

  # Writes rows to a table
  #
  # table        - name of file as String
  # valuesString - String like "(value1,value2),(value3,value4)"
  def DatabaseHelper.writeTable(valuesString,table)
    $sql.exec("INSERT INTO #{table} VALUES #{valuesString}")
  end

  # Counts the number of lines in a table
  # 
  # table = String name of table to check
  # 
  # Returns Int of row count
  def DatabaseHelper.count(table)
    $sql.exec("SELECT COUNT(*) FROM #{table}").to_a[0]["count"].to_i
  end

end