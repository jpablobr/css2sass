require 'haml'
require 'sass/css'
require 'json'
require 'rack-flash'
require 'sinatra/redirect_with_flash'

class Css2sass < Sinatra::Base
  use Rack::Flash, :sweep => true
  enable :sessions
  set :public, File.dirname(__FILE__) + '/static'
	set :show_exceptions, true if development?
  set :raise_errors, false

  helpers do
    include Rack::Utils
    alias_method :h, :escape_html
  end

  get "/" do
    haml :index
  end

  post "/*" do
    if params["page"]
      @css = params["page"]["css"]
      css_to_sass(params["commit"])

      if params[:splat].include?("json")
        {:page => {:css => @css, :sass => @sass}}.to_json
      elsif params[:splat].include?("xml")
        to_xml
      else
        haml :index
      end
    end
  end

  def css_to_sass(type={})
    if type["commit"] == "Convert 2 SCSS"

      if convert_to_scss(@css).class == String
        @sass = convert_to_scss(@css)
        flash[:error] = '' # TODO: Fix this shit!
        flash[:success] = 'Creativity is a habit.'
      else
        flash[:success] = '' # TODO: Same crap!
        flash[:error] = "Dude, nasty error! - #{@error}"
      end
    else
      if convert_to_sass(@css).class == String
        @sass = convert_to_sass(@css)
        flash[:error] = ''
        flash[:success] = 'Creativity is a habit.'
      else
        flash[:success] = ''
        flash[:error] = "Dude, nasty error! - #{@error}"
      end
    end
  end

  def convert_to_sass(css)
    begin
      Sass::CSS.new(@css).render(:sass)
    rescue StandardError => e
      @error = e
    end
  end

  def convert_to_scss(css)
    begin
      Sass::CSS.new(@css).render(:scss)
    rescue StandardError => e
      @error = e
    end
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
end
