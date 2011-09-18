require File.dirname(__FILE__) + '/../css2sass'
require 'minitest/autorun'
require 'rack/test'

class TestCss2sass < MiniTest::Unit::TestCase
  def setup
    @browser = Rack::Test::Session.new(Rack::MockSession.new(Css2sass))
  end

  def test_it_says_hello_world
    @browser.get '/'
    assert @browser.last_response.ok?
    assert_match home_title, @browser.last_response.body
  end

  def test_api_speak_json
    @browser.post '/json', json_post
    assert @browser.last_response.ok?
    assert_match json_response, @browser.last_response.body
  end

  def test_api_speak_xml
    @browser.post '/xml', xml_post
    assert @browser.last_response.ok?
    assert_match xml_response, @browser.last_response.body
  end

  def home_title
    '<title>' +
      'css2sass | Convert CSS Snippets to Syntactically Awesome StyleSheets code' +
    '</title>'
  end

  def json_post
    { :page =>
      { :css => ".content-navigation { border-color: #3bbfce; color: #2b9eab; }"
      }
    }
  end

  def json_response
    '{"page":' +
      '{"css":".content-navigation { border-color: #3bbfce; color: #2b9eab; }",'+
      '"sass":".content-navigation\n  border-color: #3bbfce\n  color: #2b9eab\n"}}'
  end

  def xml_post
    { :page =>
      { :css => ".content-navigation { border-color: #3bbfce; color: #2b9eab; }"
      }
    }
  end

  def xml_response
    "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
    "<page>\n  " +
    "<css>\n    " +
    "<![CDATA[.content-navigation { border-color: #3bbfce; color: #2b9eab; }]]>\n  " +
    "</css>\n  " +
    "<sass>\n    " +
    "<![CDATA[.content-navigation\n  border-color: #3bbfce\n  color: #2b9eab\n]]>\n  " +
    "</sass>\n" +
    "</page>\n"
  end

end
