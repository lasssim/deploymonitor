# bundler
require 'rubygems'
require 'bundler'

Bundler.setup
Bundler.require(:default)

Ngrok::Tunnel.start(port: 8080)
puts "+-------------------"
puts "| #{Ngrok::Tunnel.ngrok_url}"
puts "+-------------------"


client = Octokit::Client.new(netrc: true)
repo = "lister/stairlightsrb"
client.edit_hook(repo, 9596053, "web", { url: Ngrok::Tunnel.ngrok_url, content_type: "json" })


# sinatra
require './app' # assumes app.rb
 
use Rack::ShowExceptions

run App.new
