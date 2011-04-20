require 'rubygems'
require 'bundler'
Bundler.require
require './css2sass.rb'

set :environment, :production
disable :run

run Css2sass
