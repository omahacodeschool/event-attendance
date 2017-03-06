class Comment
  
  # creates a comment and adds it to database
  #
  # params - Hash, fullname = String
  def Comment.create(params, fullname, event_id)
    values = [$database.next_id("comments"), event_id, fullname, params[:comment].strip.split.join(" "),Time.now.to_i]
    $database.newRow(values, "comments")
  end

  def Comment.for_event
    idFilter = Proc.new do |row|
      row["eventid"] == @id
    end
    $database.all_with_filter("comments", idFilter)
  end
end