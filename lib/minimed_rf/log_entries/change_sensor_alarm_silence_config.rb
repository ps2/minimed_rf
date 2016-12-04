
module MinimedRF
  module PumpEvents
    class ChangeSensorAlarmSilenceConfig < Base
      def self.event_type_code
        0x53
      end

      def bytesize
        8
      end

      def alert_type_str
      end

      def alert_type
        # 0=off, 1=hi, 2=lo, 4=hi_lo, 8=all
        case d(1)
        when 0
          :off
        when 1
          :high
        when 2
          :low
        when 4
          :high_low
        when 8
          :all
        else
          :unknown
        end
      end

      def duration
        ((d(4) & 0b11100000) << 3) + d(7)
      end

      def timestamp
        parse_date(2)
      end

      def to_s
        "ChangeSensorAlarmSilenceConfig (alert_type=#{alert_type}) (duration=#{duration}m) #{timestamp_str}"
      end


    end
  end
end
