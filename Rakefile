# encoding: UTF-8

# Copyright 2012 Twitter, Inc
# http://www.apache.org/licenses/LICENSE-2.0

require 'rubygems' unless ENV['NO_RUBYGEMS']

require 'bundler'
require 'digest'

require 'rubygems/package_task'

require './lib/cskit-strongs'
require 'cskit'

Bundler::GemHelper.install_tasks

namespace :update do
  task :default => [:concordance, :lexicon]

  task :concordance do
    require 'fileutils'

    input_file = File.join(CSKitStrongs.vendor_dir, "concordance.txt")
    output_dir = File.join(CSKitStrongs.resource_dir, "concordance")
    splitter = CSKitStrongs::Splitters::ConcordanceSplitter.new(input_file)
    total_lines = `wc -l #{input_file}`.strip.to_i
    file_contents = {}

    puts "Processing concordance..."

    splitter.each_with_index do |(language, number, text, citation), index|
      # break if index > 1000
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

    puts "\nWriting to disk..."

    file_contents.each do |path, contents|
      FileUtils.mkdir_p(File.dirname(path))
      File.open(path, "w+") { |f| f.write(contents.to_json) }
    end

    puts "Done."
  end

  task :lexicon do
    require 'fileutils'
    BLOCK_SIZE = 100

    input_file = File.join(CSKitStrongs.vendor_dir, "lexicon.xml")
    output_dir = File.join(CSKitStrongs.resource_dir, "lexicon")
    splitter = CSKitStrongs::Splitters::LexiconSplitter.new(input_file)
    FileUtils.mkdir_p(output_dir)

    puts "Processing lexicon..."

    splitter.each_slice(BLOCK_SIZE).with_index do |entries, index|
      File.open(File.join(output_dir, "#{index}.json"), "w+") do |f|
        f.write(
          entries.inject({}) do |ret, entry|
            ret[entry.first.to_i] = entry.last
            ret
          end.to_json
        )
      end
    end

    puts "Done."
  end
end
