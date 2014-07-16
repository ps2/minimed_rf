#!/usr/bin/env ruby

#???????x ??????xxxxxxxxxx ??????xxxxxxxxxx ????xxxxxxxxxxxx ???????? MMxxxxxx MMxxxxxx ???xxxxx ???xxxxx ???xxxxx
#logtype  pgm amount (4.1) amount (4.1)     unabsorbed       ????     seconds  minutes  hours    day      year
# MM = month bits

# 17:43:31,,,,,,,Normal,4.1,4.1,,,,,,,,,,,,,,,,,,,,,BolusNormal
#00000001 0000000010100100 0000000010100100 0000000000110100 00000000 00011111 01101011 00110001 01100011 00001110
#01       00a4             00a4             0034             00       1f       6b       31       63       0e

# From the future! 2016
# 1.5 bolus @ 11:14 (37s?) PM  Jan 1, 2016
#00000001 0000000000111100 0000000000111100 0000000000000000 00000000 00100101 01001110 00110111 01100001 00010000
#01       003c             003c             0000             00       25       4e       37       61       10

# From the past:
# 1.4 bolus @ 12:11 am Dec 1, 2013
#00000001 0000000000111000 0000000000111000 0000000000111000 00000000 11101011 00001011 00100000 01100001 00001101
#01       0038             0038             0038             00       eb       0b       20       61       0d

module MinimedRF
  module PumpEvents
    class BolusNormal < Base

      def self.event_type_code
        0x01
      end

      def length
        13
      end

      def insulin_decode(a, b)
        ((a << 8) + b) / 40.0
      end

      def amount
        insulin_decode(d(1), d(2))
      end

      def to_s
        "#{bolus_type} #{timestamp_str} #{amount} #{programmed_amount} #{unabsorbed_insulin_total}"
      end

      def timestamp
        parse_date(8)
      end

      def programmed_amount
        insulin_decode(d(3), d(4))
      end

      def unabsorbed_insulin_total
        insulin_decode(d(5), d(6))
      end

      def bolus_type
        {1 => "BolusNormal"}[d(0)]
      end

      def valid_for(date_range)
        super && amount < 30 && programmed_amount < 30
      end

    end
  end
end
