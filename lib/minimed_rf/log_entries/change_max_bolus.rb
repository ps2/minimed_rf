
module MinimedRF
  module PumpEvents
    class ChangeMaxBolus < Base
      def self.event_type_code
        0x24
      end

      def length
        7
      end

      def to_s
        "ChangeMaxBolus #{timestamp_str}"
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end
