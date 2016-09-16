# 210026780D030E

# [2014, 1, 3, 13, 56, 38]

module MinimedRF
  module PumpEvents
    class Questionable3b < Base
      def self.event_type_code
        0x3b
      end

      def bytesize
        7
      end

      def to_s
        "Questionable3b #{timestamp_str}"
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end
