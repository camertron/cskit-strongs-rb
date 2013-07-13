require 'cskit'
require 'cskit/bible/kjv'
require 'cskit/concordances/strongs'

volume = CSKit.get_volume(:bible_kjv)
citation = volume.parse_citation("Neh. 6:1 (to 1st ;)")
readings = volume.readings_for(citation)
formatter = CSKit::Formatters::Bible::BiblePlainTextFormatter.new
an = CSKit.get_annotator(:strongs)
an.annotate(readings.first, volume)

# puts formatter.format_readings(readings)