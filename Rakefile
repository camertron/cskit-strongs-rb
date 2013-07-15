# encoding: UTF-8

# Copyright 2012 Twitter, Inc
# http://www.apache.org/licenses/LICENSE-2.0

require 'rubygems' unless ENV['NO_RUBYGEMS']

require 'bundler'
require 'digest'
require 'fileutils'

require 'rubygems/package_task'

require './lib/cskit-strongs'
require 'cskit'

Bundler::GemHelper.install_tasks

class LexiconUpdater
  BLOCK_SIZE = 100

  attr_reader :lexicon_lang, :splitter_class

  def initialize(lexicon_lang, splitter_class)
    @lexicon_lang = lexicon_lang
    @splitter_class = splitter_class
  end

  def update
    splitter = splitter_class.new(input_file)
    FileUtils.mkdir_p(output_dir)

    puts "Processing #{lexicon_lang} lexicon..."

    splitter.each_slice(BLOCK_SIZE).with_index do |entries, index|
      File.open(File.join(output_dir, "#{index}.json"), "w+") do |f|
        f.write(
          entries.inject({}) do |ret, entry|
            ret[entry.first] = entry.last
            ret
          end.to_json
        )
      end
    end

    puts "Done."
  end

  private

  def input_file
    @input_file ||= File.join(CSKitStrongs.vendor_dir, "#{lexicon_lang}_lexicon.xml")
  end

  def output_dir
    @output_dir ||= File.join(CSKitStrongs.resource_dir, "lexicon/#{lexicon_lang}")
  end
end

class ConcordanceUpdater
  def update
    puts "Processing concordance..."
    file_contents = split

    puts "\nWriting to disk..."
    write_to_disk(file_contents)

    puts "Done."
  end

  private

  def write_to_disk(file_contents)
    file_contents.each do |path, contents|
      FileUtils.mkdir_p(File.dirname(path))
      File.open(path, "w+") { |f| f.write(contents.to_json) }
    end
  end

  def split
    total_lines = `wc -l #{input_file}`.strip.to_i
    splitter = CSKitStrongs::Splitters::ConcordanceSplitter.new(input_file)
    file_contents = {}

    splitter.each_with_index do |(language, number, text, citation), index|
      book = citation.book.strip.downcase.gsub(" ", "_")
      chapter = citation.chapter_list.first.chapter_number
      verse = citation.chapter_list.first.verse_list.first.start.to_i
      path = File.join(output_dir, book, "#{chapter}.json")

      ((file_contents[path] ||= {})[verse] ||= []) << {
        :text => text,
        :number => number
      }

      if index % 1000 == 0
        $stdout.write("\rProcessing #{index} of #{total_lines} (#{((index.to_f / total_lines.to_f) * 100).round(2)})")
      end
    end

    file_contents
  end

  def input_file
    @input_file ||= File.join(CSKitStrongs.vendor_dir, "concordance.txt")
  end

  def output_dir
    @output_dir ||= File.join(CSKitStrongs.resource_dir, "concordance")
  end
end

namespace :update do
  task :default => [:concordance, :lexicon]

  task :concordance do
    ConcordanceUpdater.new.update
  end

  task :greek_lexicon do
    splitter_class = CSKitStrongs::Splitters::GreekLexiconSplitter
    LexiconUpdater.new("greek", splitter_class).update
  end

  task :hebrew_lexicon do
    splitter_class = CSKitStrongs::Splitters::HebrewLexiconSplitter
    LexiconUpdater.new("hebrew", splitter_class).update
  end
end
