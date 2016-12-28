require_relative 'config/environment'

use Rack::ShowExceptions

run App.new
