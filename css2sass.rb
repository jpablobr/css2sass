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
    if type.eql?("Convert 2 SCSS")
      @sass = convert_to_scss(@css)
      if sass?(@sass)
        flash_notice
      else
        flash_error
      end
    else
      @sass = convert_to_sass(@css)
      if sass?(@sass)
        flash_notice
      else
        flash_error
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

  def flash_notice
    flash[:error] = ''
    flash[:success] = 'Creativity is a habit.'
  end

  def flash_error
    flash[:success] = ''
    flash[:error] = "Dude, nasty error! - #{@error}"
  end

  def sass?(what)
    convert_to_sass(what).class == String
  end
end
