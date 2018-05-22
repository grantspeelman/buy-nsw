RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

module FactoryBot
  module Syntax
    module Methods
      def build_abn(n)
        main = n.to_s.rjust(9, "0")
        weights = [3, 5, 7, 9, 11, 13, 15, 17, 19]
        sum = 0
        (0..8).each do |i|
          digit = main[i,1].to_i
          sum += weights[i] * digit
        end
        checksum = 99 - sum % 89
        checksum_string = checksum.to_s.rjust(2, "0")
        checksum_string + main
      end
    end
  end
end
