# encoding: UTF-8

module CSKitStrongs

  StrongsNumber = Struct.new(:language, :number) do
    def self.from_string(str)
      lang = case str[0...1]
        when "g" then "greek"
        when "h" then "hebrew"
        else
          nil
      end

      StrongsNumber.new(lang, str[1..-1].to_i)
    end

    def to_s
      "#{language[0...1]}#{number}"
    end

    def greek?
      language.downcase == "greek"
    end

    def hebrew?
      language.downcase == "hebrew"
    end
  end

end