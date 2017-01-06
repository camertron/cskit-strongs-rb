# encoding: UTF-8

module CSKit
  module Strongs
    module Splitters
      module Utilities

        def strip_zeroes(str)
          str.match(/([hg]?)0*(\d+)/).captures.join
        end

      end
    end
  end
end
