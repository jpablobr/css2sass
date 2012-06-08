# encoding: utf-8
require 'sinatra/base'

module Css2sass
  class App < Sinatra::Base
    use Rack::Flash, :sweep => true
    enable :sessions
    set :show_exceptions, true if development?
    set :public_folder, Proc.new { settings.root + '/../../' + 'public' }
    set :views, Proc.new { settings.root + '/../../' + 'views' }

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
          @output = Css2sass::Convert.new(@css).to_scss
        else
          @output = Css2sass::Convert.new(@css).to_sass
        end
        render_response
      end
    end

    def render_response
      if params[:splat].include?("json")
        Css2sass::Render.new(@css, @output).json
      elsif params[:splat].include?("xml")
        Css2sass::Render.new(@css, @output).xml
      else
        flash_if_successful
        haml :index
      end
    end

    def flash_if_successful
      if @output.class == Sass::SyntaxError
        flash_error
      else
        flash_notice
      end
    end

    # Flash lib is moronic!
    def flash_notice
      flash[:error] = ''
      flash[:success] = 'Creativity is a habit.'
    end

    def flash_error
      flash[:success] = ''
      flash[:error] = "Dude, nasty error! - #{@output}"
      @output = nil
    end
  end

end
