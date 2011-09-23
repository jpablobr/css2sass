require 'haml'
require 'sass/css'
require 'json'
require 'rack-flash'
require 'sinatra/redirect_with_flash'
require_relative 'convert'

module Css2sass
  class App < Sinatra::Base
    use Rack::Flash, :sweep => true
    enable :sessions
    set :public, "public"
    set :show_exceptions, true if development?

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
        if params["commit"].eql?("Convert 2 SCSS")
          @output = Convert.new(@css).to_scss
        else
          @output = Convert.new(@css).to_sass
        end
        render = Render.new(@css, @output)
        render.flash_if_successful
        render.response
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

    def flash_if_successful(data)
      if data.class == Sass::SyntaxError
        flash_error
        @output = nil
      else
        flash_notice
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
      flash[:error] = "Dude, nasty error! - #{@output}"
    end
  end
end
