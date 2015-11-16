
module MinimedRF
  module PumpEvents
    class DeleteAlarmClockTime < Base
      def self.event_type_code
        0x6a
      end

      def length
        14
      end

      def to_s
        "DeleteAlarmClockTime #{timestamp_str}"
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end
