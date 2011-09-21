require 'rubygems'
require 'bundler'
Bundler.require
require './lib/css2sass.rb'

set :environment, :production
set :public, "public"
disable :run

run Css2sass
