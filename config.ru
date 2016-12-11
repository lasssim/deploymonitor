require 'config/environment'

use Rack::ShowExceptions

run App.new
