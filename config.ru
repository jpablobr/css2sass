require 'rubygems'
require 'bundler'
Bundler.require
require './lib/css2sass.rb'

set :environment, :production
set :root, File.dirname(__FILE__)
set :views, File.dirname(__FILE__) + "/views"
set :public, "public"
disable :run

run Css2sass
