
module MinimedRF
  module PumpEvents
    class ChangeSensorAlarmSilenceConfig < Base
      def self.event_type_code
        0x53
      end

      def bytesize
        8
      end

      def to_s
        "ChangeSensorAlarmSilenceConfig #{timestamp_str}"
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end
