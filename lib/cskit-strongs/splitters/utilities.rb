# encoding: UTF-8

module CSKitStrongs
  module Splitters
    module Utilities

      def strip_zeroes(str)
        str.match(/([hg]?)0*(\d+)/).captures.join
      end

    end
  end
end