class Comment
  # creates a comment and adds it to database
  #
  # params - Hash, fullname = String
  def Comment.create(params, username, event_id)
    values = [$database.next_id("comments"), event_id, username, params[:comment].strip.split.join(" "),Time.now.to_i]
    $database.newRow("comments", "id, eventid, username, comment, timestamp", values)
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
  def Comment.edit(params, username)
    filter = "id = '#{params["commentId"]}' AND username = '#{username}'"
    $database.updateRow("comments","comment",params["textContent"],filter)
  end
end