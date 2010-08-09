require 'sinatra'
require 'css2sass.rb'  # <-- your sinatra app
require 'spec'
require 'spec/interop/test'
require 'rack/test'
require 'builder'


set :environment, :test

def app
  Sinatra::Application
end
  
describe 'The HelloWorld App' do
  include Rack::Test::Methods

  it "says hello via json" do
    post '/json', { :page => { :css => ".content-navigation { border-color: #3bbfce; color: #2b9eab; }" } }
    last_response.should be_ok
    last_response.body.should == '{"page":{"css":".content-navigation { border-color: #3bbfce; color: #2b9eab; }","sass":".content-navigation\n  border-color: #3bbfce\n  color: #2b9eab\n"}}'
  end
  
  it "says hello via xml" do
    post '/xml', { :page => { :css => ".content-navigation { border-color: #3bbfce; color: #2b9eab; }" } }
    last_response.should be_ok
    last_response.body.should == "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<page>\n  <css>\n    <![CDATA[.content-navigation { border-color: #3bbfce; color: #2b9eab; }]]>\n  </css>\n  <sass>\n    <![CDATA[.content-navigation\n  border-color: #3bbfce\n  color: #2b9eab\n]]>\n  </sass>\n</page>\n"
  end
  
end
