RSpec.describe(Comment,".create") do 

	it "checks to see if new comment is added" do
		# Setup
		DatabaseHelper.empty("comments")
		columns = "(eventid, fullname, comment, timestamp)"
		content = "('1','Rabbit','Hello Turtle','1488756156')"
		DatabaseHelper.writeToTable("comments", content, columns)

		# Exercise
		Comment.create({:comment=>"Hello Rabbit"},"Turtle","1")
		lines = DatabaseHelper.count("comments")

		# Verify
		expect(lines).to eq(2)
	
		# Teardown
		DatabaseHelper.empty("comments")
	end
end

RSpec.describe(Comment,".for_event") do 

	it "gets list of comments by criteria" do
		# Setup
		DatabaseHelper.empty("comments")
		columns = "(eventid, fullname, comment)"
		fakeRows = "('1','Allen', 'My comment.'), ('2', 'Allen','Another comment.'), ('2', 'Spencer','My thoughts.')"
		DatabaseHelper.writeToTable("comments", fakeRows, columns)

		# Exercise
		comments = Comment.for_event(2).to_a.length

		# Verify
		expect(comments).to eq(2)
	
		# Teardown
		DatabaseHelper.empty("comments")
	end
end

RSpec.describe(Comment,".edit") do

	it "checks to see if comment is edited" do
		# Setup
		DatabaseHelper.empty("comments")
		columns = "(id, eventid, fullname, comment)"
		fakeRows = "(1, '1', 'Rabbit', 'Hello Turtle.'), (2, '1', 'Turtle','Hello Rabbit')"
		DatabaseHelper.writeToTable("comments", fakeRows,  columns)

		# Exercise
		params = {'textContent'=>'Goodbye Rabbit.', 'commentId'=> '2'}
		fullName = "Turtle"
		Comment.edit(params,fullName)

		# Verify
		editedLine = $sql.exec("SELECT * FROM comments WHERE id = 2").to_a
		expect(editedLine[0]).to include("comment" => "Goodbye Rabbit.")
	
		# Teardown
		DatabaseHelper.empty("comments")
	end
end
