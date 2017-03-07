class DatabaseHelper

  def DatabaseHelper.empty(table)
    CSV.open($database.table_path(table), 'w') do |csv|
        csv = ''
    end
  end

  # Writes rows to a table
  #
  # table - name of file
  # content - array
  def DatabaseHelper.addRows(table, content)
  	CSV.open($database.table_path( table ), 'w') do |csv|
  		content.each do |row|
  			csv << row
  		end
  	end
  end

end