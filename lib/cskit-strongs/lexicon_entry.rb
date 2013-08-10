# encoding: UTF-8

module CSKitStrongs

  LEXICON_ATTRS = [:pronunciation, :unicode, :translit, :definition, :strongs_number]

  LexiconEntry = Struct.new(*LEXICON_ATTRS) do
    def self.from_hash(hash = {})
      new(
        *(LEXICON_ATTRS.map do |attr|
          hash[attr.to_sym] || hash[attr.to_s]
        end)
      )
    end
  end

end