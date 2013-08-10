# encoding: UTF-8

require 'nokogiri'

module CSKitStrongs
  module Splitters
    class HebrewLexiconSplitter

      include Enumerable
      include CSKitStrongs::Splitters::Utilities
      attr_reader :input_file

      def initialize(input_file)
        @input_file = input_file
      end

      def each
        doc = parse_file(input_file)

        results = (doc / :entry).each do |entry|
          attrs = pronunciation_for(entry).
            merge(lang_attrs_for(entry)).
            merge(definition_for(entry))

          number = strip_zeroes(entry.attributes["id"].value.downcase)
          attrs.merge!(:strongs_number => number)

          yield number, attrs
        end
      end

      private

      def parse_file(file)
        Nokogiri::XML(File.read(file))
      end

      def pronunciation_for(entry)
        pron = (entry / :w).first.attributes["pron"].value
        { :pronunciation => pron }
      end

      def lang_attrs_for(entry)
        w = (entry / :w).first
        {
          :unicode => w.text,
          :translit => w.attributes["xlit"].value
        }
      end

      def definition_for(entry)
        definition_parts = [:source, :meaning, :usage].inject([]) do |ret, tag|
          if item = (entry / tag).first
            ret << extract_definition_from(item).join
          end
          ret
        end

        definition = definition_parts.map { |part| part.strip.chomp(";") }
        { :definition => definition.join("; ") }
      end

      def extract_definition_from(entry)
        entry.children.flat_map do |child|
          case child.name
            when "w"
              if num = child.attributes["src"]
                "{{#{num.value.downcase}}}"
              else
                extract_definition_from(child)
              end
            when "text"
              if child.text.strip.empty?
                nil
              else
                child.text
              end
            else
              extract_definition_from(child)
          end
        end.compact
      end

    end
  end
end