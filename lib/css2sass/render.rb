# encoding: utf-8
require 'json'
module Css2sass
  class Render

    def initialize(css=nil, output=nil)
      @css, @output = css, output
    end

    def xml
      xml = Builder::XmlMarkup.new
      xml.instruct!
      xml.page do
        xml.css do
          xml.cdata! @css.to_s
        end
        xml.sass do
          xml.cdata! @output.to_s
        end
      end
    end

    def json
      {:page =>
        {:css => @css,
          :sass => @output
        }
      }.to_json
    end
  end
end
