class Ruhoh
  module Converter
    module Markdown
      require 'kramdown'
      def self.extensions
        ['.md', '.markdown']
      end
      def self.convert(content)
        Kramdown::Document.new(content).to_html
      end
    end
  end
end

