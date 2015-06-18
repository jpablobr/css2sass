$:.unshift File.expand_path('../', __FILE__)
require 'rubygems'
require 'sinatra'
require './lib/css2sass'

run Css2sass::App
