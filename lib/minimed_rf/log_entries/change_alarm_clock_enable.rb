
module MinimedRF
  module PumpEvents
    class ChangeAlarmClockEnable < Base
      def self.event_type_code
        0x61
      end

      def length
        7
      end

      def to_s
        "ChangeAlarmClockEnable #{timestamp_str}"
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end
