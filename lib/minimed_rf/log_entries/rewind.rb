# 210026780D030E

# [2014, 1, 3, 13, 56, 38]

module MinimedRF
  module PumpEvents
    class Rewind < Base
      def self.event_type_code
        0x21
      end

      def bytesize
        7
      end

      def to_s
        "Rewind #{timestamp_str}"
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end
