require 'sinatra'
require 'html2haml.rb'  # <-- your sinatra app
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
    post '/json', { :page => { :html => "<h1>Hello World</h1>" } }
    last_response.should be_ok
    last_response.body.should == "{\"page\":{\"haml\":\"%h1\\n  Hello World\\n\",\"html\":\"<h1>Hello World<\\/h1>\"}}"
  end
  
  it "says hello via xml" do
    post '/xml', { :page => { :html => "<h1>Hello World</h1>" } }
    last_response.should be_ok
    last_response.body.should == "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<page>\n  <html>\n    <![CDATA[<h1>Hello World</h1>]]>\n  </html>\n  <haml>\n    <![CDATA[%h1\n  Hello World\n]]>\n  </haml>\n</page>\n"
  end
  
end