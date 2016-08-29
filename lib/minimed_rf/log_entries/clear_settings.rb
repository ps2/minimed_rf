
# 2200b2210a1d10

module MinimedRF
  module PumpEvents
    class ClearSettings < Base

      def self.event_type_code
        0x22
      end

      def bytesize
        7
      end

      def to_s
        "ClearSettings #{timestamp_str}"
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end
