require File.dirname(__FILE__) + '/../css2sass'
require 'bundler'
Bundler.require
require 'rack/test'
require 'rspec'

# set test environment
set :environment, :test

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

def app
  @app ||= Sinatra::Application
end
