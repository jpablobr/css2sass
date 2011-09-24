require 'rubygems'
require 'bundler'

begin
  require 'bundler/setup'
  Bundler.require(:default)
rescue Bundler::GemNotFound
  raise RuntimeError, "Bundler couldn't find some gems."
end

require './lib/css2sass'

set :environment, :production
disable :run

run Css2sass::App
