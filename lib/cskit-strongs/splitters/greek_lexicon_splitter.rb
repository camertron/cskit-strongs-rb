# encoding: UTF-8

require 'nokogiri'

module CSKitStrongs
  module Splitters
    class GreekLexiconSplitter

      LANG = :greek

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
            merge(lang_attrs_for(entry, LANG)).
            merge(definition_for(entry))

          number = "g#{strip_zeroes(entry.attributes["strongs"].value)}"
          attrs.merge!(:strongs_number => number)

          yield number, attrs
        end
      end

      private

      def parse_file(file)
        Nokogiri::XML(File.read(file))
      end

      def pronunciation_for(entry)
        attrs = (entry / :pronunciation).first
        { :pronunciation => attrs ? attrs.attributes["strongs"].value : nil }
      end

      def lang_attrs_for(entry, lang)
        attrs = (entry / lang).first
        {
          :unicode  => attrs ? attrs.attributes["unicode"].value : nil,
          :translit => attrs ? attrs.attributes["translit"].value : nil
        }
      end

      def definition_for(entry)
        parts = definition_parts_for(entry)

        definition = parts[1..-1].map do |part|
          part.gsub("\n", "")
        end.join

        { :definition => "[#{parts.first}] #{definition}" }
      end

      def definition_parts_for(node)
        node.children.flat_map do |child|
          case child.name
            when "strongs_derivation", "strongs_def"
              definition_parts_for(child)
            when "greek"
              [child.attributes["unicode"].value.strip]
            when "strongsref"
              lang = child.attributes["language"].value.chars.first.downcase
              number = strip_zeroes(child.attributes["strongs"].value.to_s)
              "{{#{lang}#{number}}}"
            when "text"
              if child.text.strip.empty?
                nil
              else
                child.text
              end
          end
        end.compact
      end

    end
  end
end