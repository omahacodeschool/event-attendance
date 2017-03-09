class DatabaseHelper

  def DatabaseHelper.empty(table)
    $sql.exec( "DELETE FROM #{table}" )
  end

  # Writes rows to a table
  #
  # table - name of file
  # valuesString - string like "(value1,value2),(value3,value4)"
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
    $sql.each do |each|
      connection.exec( "INSERT INTO #{table}(#{attributes}) VALUES (#{each})" )
    end
  end

end