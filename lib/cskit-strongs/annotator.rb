# encoding: UTF-8

require 'json'

module CSKitStrongs
  class Annotator << CSKit::Annotator

    def annotate(reading)
      reading.verse.start.upto(reading.verse.finish) do |i|
        
      end
    end

    private

    def concordance_resource_for(reading)
      book = reading.citation.book_for_path
      path = File.join(concordance_path, )
    end

    def concordance_path
      @concordance_path ||= File.join(CSKitStrongs.resource_dir, "concordance")
    end

  end
end