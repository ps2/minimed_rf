# 6304F217161A0D


module MinimedRF
  module PumpEvents
    class ChangeAlarmNotifyMode < Base
      def self.event_type_code
        0x63
      end

      def bytesize
        7
      end

      def to_s
        "ChangeAlarmNotifyMode #{timestamp_str} Mode=#{mode}"
      end

      def mode
        {
          # TODO: other values?
          4 => "vibration"
        }[d(1)]
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end
