require 'rubygems'
require 'bundler/setup'
require 'sinatra'

set :environment, :production
disable :run

require 'css2sass.rb'

run Sinatra::Application