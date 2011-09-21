require 'haml'
require 'sass/css'
require 'json'
require 'rack-flash'
require 'sinatra/redirect_with_flash'

class Css2sass < Sinatra::Base
  use Rack::Flash, :sweep => true
  enable :sessions
	set :show_exceptions, true if development?
  set :public, File.dirname(__FILE__) + '/public'

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
      @output = css_to_sass
      flash_if_successful(@output)
      render_response
    end
  end

  def render_response
    if params[:splat].include?("json")
      render_json
    elsif params[:splat].include?("xml")
      render_xml
    else
      haml :index
    end
  end

  def css_to_sass
    if params["commit"].eql?("Convert 2 SCSS")
      convert_to_scss(@css)
    else
      convert_to_sass(@css)
    end
  end

  def flash_if_successful(data)
    if sass?(data)
      flash_notice
    else
      flash_error
    end
  end

  def sass?(data)
    convert_to_sass(data).class == String
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

  def render_xml
    builder do |xml|
      xml.instruct!
      xml.page do
        xml.css do
          xml.cdata! @css
        end
        xml.sass do
          xml.cdata! @output
        end
      end
    end
  end

  def render_json
    {:page =>
      {:css => @css,
        :sass => @output
      }
    }.to_json
  end

  def flash_notice
    flash[:error] = ''
    flash[:success] = 'Creativity is a habit.'
  end

  def flash_error
    flash[:success] = ''
    flash[:error] = "Dude, nasty error! - #{@error}"
  end
end
