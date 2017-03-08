
RSpec.describe(Database, "#all_with_filter") do
	it 'gets a specified row' do
		array = [["header1","header2"],["1","test 1"],["2","test 2"]]
		CSV.open($database.table_path("comments"), "wb") do |csv|
			array.each do |row|
     		csv << row
     		end
   		end

   		filter = Proc.new do |row|
     		row["header1"] == "1"
   		end

		list = $database.all_with_filter("comments", filter)
		expect(list).to include("1", "test 1")
	end 

	# TODO Add in this test, or add the assertion to the previous test case.
	# it 'only gets the specified number of rows' do
	# 	array = [["header1","header2"],["1","test 1"],["2","test 2"]]
	# 	CSV.open($database.table_path("comments"), "wb") do |csv|
	# 		array.each do |row|
 #     		csv << row
 #     		end
 #   		end

 #   		filter = Proc.new do |row|
 #     		row["header1"] == "1"
 #   		end

	# 	list = $database.all_with_filter("comments", filter)
	# 	expect(list.length).to eq(1)
	# end 

end 


