require "rubygems"
require "bundler"
Bundler.require(:default)

require 'csv'
require 'json'
require 'net/http'
require 'date'
require 'time'
require 'bcrypt'

require_relative "services/login.rb"
require_relative "models/event.rb"
require_relative "models/user.rb"
require_relative "models/rsvp.rb"
require_relative "models/comment.rb"
require_relative "services/meetup.rb"

require_relative "controller.rb"
require_relative "services/database.rb"

$database = Database.new
enable :sessions

