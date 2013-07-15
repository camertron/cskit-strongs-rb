# encoding: UTF-8

require 'json'

module CSKitStrongs
  module Splitters
    class ConcordanceSplitter

      include Enumerable
      include CSKitStrongs::Splitters::Utilities
      attr_reader :input_file

      PARSER_CONST = CSKit::Parsers::BibleParser

      def initialize(input_file)
        @input_file = input_file
      end

      def each
        File.open(input_file) do |f|
          until f.eof?
            # split strongs line into [number, text, citation], split citation into [book, "chapter:verse"]
            parts = f.readline.match(/([hg]\d{4})(.*)(\-[\w\d]{2,3}.*)/).captures.map(&:strip)
            citation_parts = parts.last.match(/\-([\w\d]{2,3})(.*)/).captures

            # replace strong's book name with something we understand
            citation_text = "#{book_map[citation_parts.first]}#{citation_parts.last}"

            number = strip_zeroes(parts[0])
            text = parts[1]
            citation = parser.parse(citation_text).to_object

            yield language, number, text, citation
          end
        end
      end

      private

      def book_map
        @book_map = JSON.parse(File.read(File.join(CSKitStrongs.vendor_dir, "book_map.json")))
      end

      def parser
        @parser ||= PARSER_CONST.new
      end

    end
  end
end