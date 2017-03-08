class Comment
  # creates a comment and adds it to database
  #
  # params - Hash, fullname = String
  def Comment.create(params, fullname, event_id)
    values = [$database.next_id("comments"), event_id, fullname, params[:comment].strip.split.join(" "),Time.now.to_i]
    binding.pry
    $database.newRow(values, "comments")
  end

  def Comment.for_event(eventid)
    idFilter = "eventid = '#{eventid}' ORDER BY id"
    $database.all_with_filter("comments", idFilter)
  end

  # Edits a comment. 
  # 
  # params - Hash, user = String
  # 
  # no return but deletes a comment, writes the new version
  #   then sorts the comments based on Id so they appear in
  #   the same spot as before edit
  def Comment.edit(commentId, user_fullname)
    filter = "id = '#{commentId}' AND fullname = '#{user_fullname}'"
    $database.updateRow("comments","comment",params["textContent"],filter)
  end
end