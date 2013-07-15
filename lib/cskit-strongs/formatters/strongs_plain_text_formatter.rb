# encoding: UTF-8

module CSKitStrongs
  module Formatters
    class StrongsPlainTextFormatter < CSKit::Formatters::Formatter

      def format_annotation(annotation, text)
        "#{text} [#{annotation.data.unicode}]"
      end

    end
  end
end