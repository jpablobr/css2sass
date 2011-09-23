require 'rubygems'
require 'bundler'
Bundler.require
require './lib/css2sass'

set :environment, :production
disable :run

run Css2sass::App
