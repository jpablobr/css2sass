require 'sinatra'
# Sinatra
app_file = File.join(File.dirname(__FILE__), *%w[.. .. html2haml.rb])
require app_file
# Force the application name because polyglot breaks the auto-detection logic.
Sinatra::Application.app_file = app_file

# RSpec matchers
require 'spec/expectations'

# Webrat
require 'webrat'
Webrat.configure do |config|
  config.mode = :sinatra
end

World do
  session = Webrat::SinatraSession.new
  session.extend(Webrat::Matchers)
  session.extend(Webrat::HaveTagMatcher)
  session
end
