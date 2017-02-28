class Database
  def all(table)
    list = []
    CSV.foreach("#{table}.csv", {headers: true, return_headers: false}) do |row|
      list.push(row.to_hash)
    end

    return list
  end
end