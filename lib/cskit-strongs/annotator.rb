# encoding: UTF-8

require 'json'

module CSKitStrongs
  class Annotator < CSKit::Annotator

    def annotate(reading, volume)
      annotated_reading = reading.to_annotated_reading
      resource = concordance_resource_for(reading, volume)

      reading.texts.each_with_index do |text, index|
        verse_num = reading.verse.start + index
        corresponding_verse_texts = resource[verse_num.to_s]

        each_annotation_for(text, corresponding_verse_texts) do |annotation|
          annotated_reading.add_annotation(index, annotation)
        end
      end

      annotated_reading
    end

    def get_formatter(type = :plain_text)
      case type
        when :plain_text
          CSKitStrongs::Formatters::StrongsPlainTextFormatter
        when :html
          CSKitStrongs::Formatters::StrongsHtmlFormatter
      end
    end

    def available_formatters
      [:plain_text, :html]
    end

    private

    BATCH_SIZE = 100

    def each_annotation_for(text, corresponding_verse_texts, &block)
      enum = Enumerator.new do |yielder|
        corresponding_verse_texts.each do |verse_text|
          parts = split_on_last_word(verse_text["text"])
          regex = /#{Regexp.escape(parts.first)}(#{Regexp.escape(parts.last)})/

          if matches = text.match(regex)
            start, finish = matches.offset(1)
            strongs_number = StrongsNumber.from_string(verse_text["number"])
            lexicon_entry = lexicon_entry_for(strongs_number)

            if lexicon_entry
              yielder.yield(CSKit::Annotation.new(start, finish - 1, lexicon_entry))
            end
          end
        end
      end

      block_given? ? enum.each(&block) : enum
    end

    def lexicon_entry_for(strongs_number)
      batch_number = batch_number_for(strongs_number)
      path = lexicon_path_for(batch_number, strongs_number.language)
      lexicon = (lexicon_cache[batch_number] ||= JSON.parse(File.read(path)))
      LexiconEntry.from_hash(lexicon[strongs_number.to_s])
    rescue Errno::ENOENT  # couldn't load file
      nil
    end

    def split_on_last_word(text)
      if idx = text.rindex(" ")
        [text[0..idx], text[(idx + 1)..-1]]
      else
        ["", text]
      end
    end

    def concordance_resource_for(reading, volume)
      path = concordance_path_for(reading, volume)
      concordance_cache[path] ||= JSON.parse(File.read(path))
    end

    def concordance_path_for(reading, volume)
      book = volume.unabbreviate_book_name(reading.citation.book).downcase
      chapter = reading.chapter.chapter_number
      File.join(concordance_base_path, book, "#{chapter}.json")
    end

    def lexicon_path_for(batch_number, language)
      File.join(lexicon_base_path, language, "#{batch_number}.json")
    end

    def batch_number_for(strongs_number)
      (strongs_number.number - 1) / BATCH_SIZE
    end

    def concordance_base_path
      @concordance_base_path ||= File.join(CSKitStrongs.resource_dir, "concordance")
    end

    def lexicon_base_path
      @lexicon_base_path ||= File.join(CSKitStrongs.resource_dir, "lexicon")
    end

    def concordance_cache
      @concordance_cache ||= {}
    end

    def lexicon_cache
      @lexicon_cache ||= {}
    end

  end
end