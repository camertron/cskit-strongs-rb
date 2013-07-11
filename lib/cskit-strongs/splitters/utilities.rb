# encoding: UTF-8

module CSKitStrongs
  module Splitters
    module Utilities

      def strip_zeroes(str)
        str.match(/0*(\d+)/).captures.first
      end

    end
  end
end