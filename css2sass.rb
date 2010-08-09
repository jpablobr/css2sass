require "haml"
require "sass/css"
require "json"

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

get "/" do
  haml :index
end


post "/*" do
  puts params
  if params["page"]
    @css = params["page"]["css"]
    @sass = convert(@css)
    if params[:splat].include?("json")
      {:page => {:css => @css, :sass => @sass}}.to_json
    elsif params[:splat].include?("xml")
      to_xml
    else
      haml :index
    end
  end
end

def convert(css)
  Sass::CSS.new(@css).render
end

def to_xml
  builder do |xml|
    xml.instruct!
    xml.page do
      xml.css do
        xml.cdata! @css
      end
      xml.sass do
        xml.cdata! @sass
      end
    end
  end  
end
