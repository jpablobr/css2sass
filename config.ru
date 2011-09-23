require 'rubygems'
require 'bundler'
Bundler.require
require './lib/css2sass.rb'

set :environment, :production
disable :run

run Css2sass::App
