require 'spec_helper'

describe Css2sass do

  context 'the API' do
    it "speak json" do
      post '/json', { :page => { :css => ".content-navigation { border-color: #3bbfce; color: #2b9eab; }" } }
      last_response.should be_ok
      last_response.body.should == '{"page":{"css":".content-navigation { border-color: #3bbfce; color: #2b9eab; }","sass":".content-navigation\n  border-color: #3bbfce\n  color: #2b9eab\n"}}'
    end

    it "speak XML" do
      post '/xml', { :page => { :css => ".content-navigation { border-color: #3bbfce; color: #2b9eab; }" } }
      last_response.should be_ok
      last_response.body.should == "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<page>\n  <css>\n    <![CDATA[.content-navigation { border-color: #3bbfce; color: #2b9eab; }]]>\n  </css>\n  <sass>\n    <![CDATA[.content-navigation\n  border-color: #3bbfce\n  color: #2b9eab\n]]>\n  </sass>\n</page>\n"
    end

  end
end
