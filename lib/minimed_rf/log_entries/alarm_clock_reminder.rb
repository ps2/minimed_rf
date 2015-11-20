# 350040300e040e

module MinimedRF
  module PumpEvents
    class AlarmClockReminder < Base

      def self.event_type_code
        0x35
      end

      def bytesize
        7
      end

      def to_s
        "AlarmClockReminder #{timestamp_str} type:#{d(1)}"
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end
