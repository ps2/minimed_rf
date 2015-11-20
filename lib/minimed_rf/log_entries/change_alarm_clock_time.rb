# 6304F217161A0D


module MinimedRF
  module PumpEvents
    class ChangeAlarmClockTime < Base
      def self.event_type_code
        0x32
      end

      def bytesize
        14
      end

      def to_s
        "ChangeAlarmClockTime #{timestamp_str}"
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end
