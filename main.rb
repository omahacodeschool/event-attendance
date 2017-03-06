require 'sinatra'
require 'pry'
require 'csv'
require 'json'
require 'net/http'

require_relative "services/database.rb"
$database = Database.new

require_relative "services/login.rb"
require_relative "models/event.rb"
require_relative "models/user.rb"
require 'date'
enable :sessions

require_relative "controller.rb"