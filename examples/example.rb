require 'cskit'
require 'cskit/bible/kjv'
require 'cskit/concordances/strongs'

include CSKitStrongs::Formatters
include CSKit::Formatters::Bible

dir = File.dirname(__FILE__)

volume = CSKit.get_volume(:bible_kjv)
citation = volume.parse_citation("Neh. 1:1-6")
readings = volume.readings_for(citation)
formatter = BiblePlainTextFormatter.new
strongs = CSKit.get_annotator(:strongs)

annotated_readings = readings.map do |reading|
  strongs.annotate(reading, volume)
end

template = File.read(File.join(dir, "template.html"))
outfile = File.join(dir, "output.html")

File.open(outfile, "w+") do |f|
  fmt_text = formatter.format_annotated_readings(annotated_readings, StrongsHtmlFormatter.new)
  f.write(template.gsub("{{body}}", fmt_text))
end

puts "Wrote #{outfile} successfully."
