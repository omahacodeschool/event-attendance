require 'sinatra'

get "/event" do
	erb :event
end

get "/"  do 
	
	erb :index

end



