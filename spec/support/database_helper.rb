class DatabaseHelper

  def DatabaseHelper.empty(table)
    CSV.open($database.table_path(table), 'w') do |csv|
        csv = ''
    end
  end

end