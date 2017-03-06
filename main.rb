require 'sinatra'
require 'pry'
require 'csv'
require 'json'
require 'net/http'
require 'date'

require_relative "services/login.rb"
require_relative "models/event.rb"
require_relative "models/user.rb"
require_relative "controller.rb"
require_relative "services/database.rb"
$database = Database.new

enable :sessions

