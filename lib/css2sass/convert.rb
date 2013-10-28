# encoding: utf-8
require 'sass/css'
module Css2sass
  class Convert

    def initialize(css, options = {})
      @css = css
      @options = options
    end

    def to_sass
      begin
        Sass::CSS.new(@css, @options).render(:sass)
      rescue Sass::SyntaxError => e
        @error = e
      end
    end

    def to_scss
      begin
        Sass::CSS.new(@css).render(:scss)
      rescue Sass::SyntaxError => e
        @error = e
      end
    end

  end

end
