class DatabaseHelper

  def DatabaseHelper.empty(table)
    $database.returnConn.exec("DELETE FROM #{table}")
  end

  def DatabaseHelper.writeTable(valuesString,table)
  		$database.returnConn.exec("INSERT INTO #{table} VALUES #{valuesString}")
  end

end