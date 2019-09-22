$:.unshift File.expand_path('../', __FILE__)
require 'rubygems'
require 'sinatra'
require './lib/css2sass'

use Rack::Session::Cookie, :key => 'rack.session',
  :expire_after => 2592000,
  :secret => ENV['RACK_SESSION_COOKIE']

run Css2sass::App
