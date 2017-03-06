RSpec.describe(Database, '#newRow') do
	
	it 'length increases by 1' do
	#set-up
		table = "events"
		CSV.open($database.table_path(table),'w') do |file|
			file << ["id","group","title","date","time","location","address","link"]
			file << ["test","test2","test3","test","test2","test3","test","test2"]
		end
		array = ["test","test2","test3","test","test2","test3","test","test2"]
	#exercise
		$database.newRow(array,table)
	#verify
		expect(File.open($database.table_path("events"), "r").readlines.size).to eq(3)
	#teardown
		system 'cp databases/events.csv spec/databases/events.csv'
	end

	it 'last line is what was added' do
	#set-up
		table = "events"
		CSV.open($database.table_path(table),'w') do |file|
			file << ["id","group","title","date","time","location","address","link"]
			file << ["test","test2","test3","test","test2","test3","test","test2"]
		end
		array = ["test","test2","test3","test","test2","test3","test","test2"]
	#exercise
		$database.newRow(array,table)
	#verify
		line_count = File.readlines($database.table_path(table)).size
		count = 0
		lastrow = []
		CSV.foreach($database.table_path(table)) do |row|
			count += 1
  			if count == line_count then lastrow = row end
  		end
		expect(lastrow).to eq(array)
	#teardown
		system 'cp databases/events.csv spec/databases/events.csv'
	end
end


RSpec.describe(Database, '#deleteRow') do
	
	it 'length decreases by 1' do
	#set-up
		table = "events"
		CSV.open($database.table_path(table),'w') do |file|
			file << ["id","group","title","date","time","location","address","link"]
			file << ["test","test2","test3","test","test2","test3","test","test2"]
		end
		filter = Proc.new do |row|
      		row[:id] == "test"
    	end
	#exercise
		$database.deleteRow(table,filter)
	#verify
		expect(File.open($database.table_path("events"), "r").readlines.size).to eq(1)
	#teardown
		system 'cp databases/events.csv spec/databases/events.csv'
	end

	it 'last line is what was added' do
	#set-up
		table = "events"
		array = ["test","test2","test3","test","test2","test3","test","test2"]
		CSV.open($database.table_path(table),'w') do |file|
			file << ["id","group","title","date","time","location","address","link"]
			file << array
		end
		filter = Proc.new do |row|
      		row[:id] == "test"
    	end
	#exercise
		$database.deleteRow(table,filter)
	#verify
		line_count = File.readlines($database.table_path(table)).size
		count = 0
		lastrow = []
		CSV.foreach($database.table_path(table)) do |row|
			count += 1
  			if count == line_count then lastrow = row end
  		end
		expect(lastrow).not_to eq(array)
	#teardown
		system 'cp databases/events.csv spec/databases/events.csv'
	end

end