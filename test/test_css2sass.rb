require_relative '../lib/css2sass'
require 'minitest/autorun'
require 'rack/test'
require 'builder'

class TestCss2sassApp < MiniTest::Unit::TestCase
  def setup
    @browser = Rack::Test::Session.new(Rack::MockSession.new(Css2sass::App))
  end

  def test_home_says_css2sass
    @browser.get '/'
    assert @browser.last_response.ok?
    assert_match home_title, @browser.last_response.body
  end

  def test_html_sass_response
    @browser.post '/', css2sass_post
    @browser.last_response.body
    assert_match html_sass_response, @browser.last_response.body
  end

  def test_html_scss_response
    @browser.post '/', css2scss_post
    assert_match html_scss_response, @browser.last_response.body
  end

  def test_api_speak_json_with_sass
    @browser.post '/json', css2sass_post
    assert_match json_sass_response, @browser.last_response.body
  end

  def test_api_speak_json_with_scss
    @browser.post '/json', css2scss_post
    assert_match json_scss_response, @browser.last_response.body
  end

  def test_api_speak_xml_with_sass
    @browser.post '/xml', css2sass_post
    assert_match xml_sass_response, @browser.last_response.body
  end

  def test_api_speak_xml_with_scss
    @browser.post '/xml', css2scss_post
    assert_match xml_scss_response, @browser.last_response.body
  end

  def home_title
    '<title>' +
      'css2sass | Convert CSS Snippets to Syntactically Awesome StyleSheets code' +
    '</title>'
  end

  def css2scss_post
    { :page =>
      { :css => ".content-navigation { border-color: #3bbfce; color: #2b9eab; }"
      },
      :commit => "Convert 2 SCSS"
    }
  end

  def css2sass_post
    { :page =>
      { :css => ".content-navigation { border-color: #3bbfce; color: #2b9eab; }"
      },
      :commit => "Convert 2 SASS"
    }
  end

  def json_sass_response
    '{"page":' +
      '{"css":".content-navigation { border-color: #3bbfce; color: #2b9eab; }",'+
      '"sass":".content-navigation\n  border-color: #3bbfce\n  color: #2b9eab\n"}}'
  end

  def json_scss_response
    '{"page":' +
      '{"css":".content-navigation { border-color: #3bbfce; color: #2b9eab; }",' +
      '"sass":".content-navigation {\n  border-color: #3bbfce;\n  color: #2b9eab; }\n"}}'
  end

  def xml_sass_response
    "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
      "<page>" +
        "<css>" +
          "<![CDATA[.content-navigation { border-color: #3bbfce; color: #2b9eab; }]]>" +
         "</css>" +
        "<sass>" +
          "<![CDATA[.content-navigation\n  border-color: #3bbfce\n  color: #2b9eab\n]]>" +
        "</sass>" +
      "</page>"
  end

  def xml_scss_response
    "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"+
      "<page>"+
        "<css>"+
          "<![CDATA[.content-navigation { border-color: #3bbfce; color: #2b9eab; }]]>"+
        "</css>"+
        "<sass>"+
          "<![CDATA[.content-navigation {\n  border-color: #3bbfce;\n  color: #2b9eab; }\n]]>"+
        "</sass>"+
      "</page>"
  end

  def html_sass_response
    "<textarea id='page_sass' name='page[sass]'>" +
      ".content-navigation&#x000A;  border-color: #3bbfce&#x000A;  color: #2b9eab" +
      "</textarea>"
  end

  def html_scss_response
    "<textarea id='page_sass' name='page[sass]'>" +
      ".content-navigation " +
      "{&#x000A;  border-color: #3bbfce;&#x000A;  color: #2b9eab; }" +
      "</textarea>"
  end

end
