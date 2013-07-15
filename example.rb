require 'cskit'
require 'cskit/bible/kjv'
require 'cskit/concordances/strongs'

include CSKitStrongs::Formatters

volume = CSKit.get_volume(:bible_kjv)
citation = volume.parse_citation("Neh. 1:1-6")
readings = volume.readings_for(citation)
formatter = CSKit::Formatters::Bible::BiblePlainTextFormatter.new
strongs = CSKit.get_annotator(:strongs)

annotated_readings = readings.map do |reading|
  strongs.annotate(reading, volume)
end

# puts annotated_readings.map(&:annotations).inspect

File.open("/Users/legrandfromage/Desktop/test.html", "w+") do |f|
  f.write(formatter.format_annotated_readings(annotated_readings, StrongsHtmlFormatter.new))
end

# puts formatter.format_readings(annotated_readings)