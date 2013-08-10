# encoding: UTF-8

module CSKitStrongs
  module Formatters
    class StrongsHtmlFormatter < StrongsPlainTextFormatter

      def format_annotation(annotation, text)
        # definition = format_number_references(annotation.data.definition)
        "<span class='cskit-strongs-word' %{data_attrs} data-definition='%{definition}'>%{text}</span>" % {
          :text => text,
          :definition => "[#{annotation.data.unicode}] #{annotation.data.definition}",
          :data_attrs => [:pronunciation, :translit, :unicode].map do |data_attr|
            value = annotation.data.send(data_attr)
            "data-#{data_attr}='#{value.gsub("'", "&#39;")}'"
          end.join(" ")
        }
      end

      # private
      # 
      # def format_number_references(str)
      #   str.gsub(/(\{\{[hg]\d{1,4}\}\})/) do |match|
      #     strongs_number = StrongsNumber.from_string(match[2..-3])
      #     "<a class='cskit-strongs-reference' data-language='%{lang}'>%{number}</a>" % {
      #       :lang => strongs_number.language,
      #       :number => strongs_number.number
      #     }
      #   end
      # end

    end
  end
end