
module MinimedRF
  module PumpEvents
    class ChangeWatchdogMarriageProfile < Base
      def self.event_type_code
        0x81
      end

      def bytesize
        12
      end

      def to_s
        "ChangeWatchdogMarriageProfile #{timestamp_str}"
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end
