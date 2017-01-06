# encoding: UTF-8

require 'cskit'
require 'cskit/bible/kjv'
require 'pathname'

module CSKit
  module Strongs
    autoload :Annotator,     'cskit/strongs/annotator'
    autoload :Formatters,    'cskit/strongs/formatters'
    autoload :LexiconEntry,  'cskit/strongs/lexicon_entry'
    autoload :Splitters,     'cskit/strongs/splitters'
    autoload :StrongsNumber, 'cskit/strongs/strongs_number'

    class << self
      def resource_dir
        @resource_dir ||= base_pathname.join('resources').to_s
      end

      def vendor_dir
        @vendor_dir ||= base_pathname.join('vendor').to_s
      end

      private

      def base_pathname
        @base_pathname ||= Pathname(__FILE__).dirname.dirname.dirname
      end
    end
  end
end

CSKit.register_annotator({
  type: :concordance,
  id: :strongs,
  name: 'The Exhaustive Concordance of the Bible',
  author: 'James Strong',
  language: 'English',
  volumes: [CSKit::Bible::Kjv::Volume],
  annotator: CSKit::Strongs::Annotator
})
