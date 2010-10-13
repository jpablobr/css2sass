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
  puts params["commit"]
  if params["page"]
    @css = params["page"]["css"]

    if params["commit"] == "Convert 2 SCSS"
      @sass = convert_to_scss(@css)
    else
      @sass = convert_to_sass(@css)
    end

    if params[:splat].include?("json")
      {:page => {:css => @css, :sass => @sass}}.to_json
    elsif params[:splat].include?("xml")
      to_xml
    else
      haml :index
    end
  end
end

def convert_to_sass(css)
  Sass::CSS.new(@css).render(:sass)
end

def convert_to_scss(css)
  Sass::CSS.new(@css).render(:scss) 
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
