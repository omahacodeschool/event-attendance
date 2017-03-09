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

  # Writes rows to a table --!important( this replaces addRows )
  #
  # table        - name of file as String
  # valuesString - String like "(value1,value2),(value3,value4)"
  def DatabaseHelper.writeTable(valuesString,table)
      $sql.exec("INSERT INTO #{table} VALUES #{valuesString}")
  end

  # Writes rows to a table
  #
  # table - name of file
  # content - array
  def DatabaseHelper.addRows(table, content)
    content.each do |chunkOfContent|

      $sql.exec( "INSERT INTO #{table} VALUES (#{chunkOfContent})")
    end
  end

  def DatabaseHelper.add_row_with_attributes(table, attributes, content)
    content.each do |each|
      $sql.exec( "INSERT INTO #{table}(#{attributes}) VALUES (#{each})" )
    end
  end

end