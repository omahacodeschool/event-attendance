class Recommend

  def Recommend.update(params, fullname)
    filter = "LOWER(url) = LOWER ('#{params[:group_name]}')"
    column_increment = "recommends = recommends::int + 1"
    $database.increment_value("meetups", column_increment, filter)
  end

  def Recommend.findGroup(id)
    groupfilter = "id = '#{id}'"
    groupid = $database.find_column_value("groupkey", "events", groupfilter).to_a[0]["groupkey"]
    idfilter = "LOWER(url) = LOWER ('#{groupid}')"
    $database.find_column_value("recommends", "meetups", idfilter).to_a[0]["recommends"]
  end

end
