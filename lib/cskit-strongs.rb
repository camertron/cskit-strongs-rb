# encoding: UTF-8

module CSKitStrongs
  class << self
    def resource_dir
      @resource_dir ||= File.join(File.dirname(File.dirname(__FILE__)), "resources")
    end

    def vendor_dir
      @vendor_dir ||= File.join(File.dirname(File.dirname(__FILE__)), "vendor")
    end
  end

  autoload :Annotator,     "cskit-strongs/annotator"
  autoload :LexiconEntry,  "cskit-strongs/lexicon_entry"
  autoload :StrongsNumber, "cskit-strongs/strongs_number"
  autoload :Formatters,    "cskit-strongs/formatters"

  module Splitters
    autoload :ConcordanceSplitter,   "cskit-strongs/splitters/concordance_splitter"
    autoload :GreekLexiconSplitter,  "cskit-strongs/splitters/greek_lexicon_splitter"
    autoload :HebrewLexiconSplitter, "cskit-strongs/splitters/hebrew_lexicon_splitter"
    autoload :Utilities,             "cskit-strongs/splitters/utilities"
  end
end
