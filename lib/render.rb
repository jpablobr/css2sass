module Css2sass
  class Render

    def initialize(css, output)
      @css, @output = css, output
    end

    def xml
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

    def json
      {:page =>
        {:css => @css,
          :sass => @output
        }
      }.to_json
    end
  end
end
