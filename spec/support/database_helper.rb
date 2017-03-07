class DatabaseHelper

  def DatabaseHelper.empty(table)
    CSV.open($database.table_path(table), 'w') do |csv|
        csv = ''
    end
  end

  def DatabaseHelper.writeCsv(array,table)
  		CSV.open($database.table_path(table),'w') do |csv|
			array.each do |row|
				csv << row
			end
		end
  end

end