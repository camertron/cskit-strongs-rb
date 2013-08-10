# encoding: UTF-8

module CSKitStrongs
  module Formatters
    class StrongsHtmlFormatter < StrongsPlainTextFormatter

      def format_annotation(annotation, text)
        "<span class='cskit-strongs-word' %{data_attrs} data-definition='%{definition}'>%{text}</span>" % {
          :text => text,
          :definition => "[#{annotation.data.unicode}] #{annotation.data.definition}",
          :data_attrs => [:pronunciation, :translit, :unicode].map do |data_attr|
            value = annotation.data.send(data_attr)
            "data-#{data_attr}='#{value.gsub("'", "&#39;")}'"
          end.join(" ")
        }
      end

    end
  end
end