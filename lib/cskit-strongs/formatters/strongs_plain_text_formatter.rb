# encoding: UTF-8

module CSKitStrongs
  module Formatters
    class StrongsPlainTextFormatter < CSKit::Formatters::Formatter

      RLE = "\u202b"  # right-to-left embedding
      PDF = "\u202c"  # pop directional formatting

      def format_annotation(annotation, text)
        unicode = if StrongsNumber.from_string(annotation.data.strongs_number).hebrew?
          "#{RLE}#{annotation.data.unicode}#{PDF}"
        else
          annotation.data.unicode
        end

        "#{text} [#{unicode}]"
      end

    end
  end
end