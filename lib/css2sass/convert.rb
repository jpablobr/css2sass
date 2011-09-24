# encoding: utf-8
require 'sass/css'
module Css2sass
  class Convert

    def initialize(css)
      @css = css
    end

    def to_sass
      begin
        Sass::CSS.new(@css).render(:sass)
      rescue StandardError => e
        @error = e
      end
    end

    def to_scss
      begin
        Sass::CSS.new(@css).render(:scss)
      rescue StandardError => e
        @error = e
      end
    end
  end
end
