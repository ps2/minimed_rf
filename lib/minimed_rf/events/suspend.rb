# 1e01 603612030e

module MinimedRF
  module PumpEvents
    class Suspend < Base
      def self.event_type_code
        0x1e
      end

      def length
        7
      end

      def to_s
        "Suspend #{timestamp_str}"
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end
