require 'rubygems'
require 'bundler'
env = ENV['RACK_ENV'] || :development
Bundler.setup(:default, env)
Bundler.require

$:.unshift(File.expand_path('../../lib', __FILE__))

require 'logger'

require 'dockerize'
require 'app'
require 'use_case'
 
require 'ngrok_tunnel'
require ::File.expand_path("../environments/#{env}",  __FILE__)


