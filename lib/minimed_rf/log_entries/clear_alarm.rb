
# 0C67440012080E
# 1782,4/8/14,18:00:04,4/8/14 18:00:04,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,ClearAlarm,"ALARM_TYPE=103, ACTION_REQUESTOR=pump",12772625731,53126704,102,MiniMed 530G - 551

module MinimedRF
  module PumpEvents
    class ClearAlarm < Base

      def self.event_type_code
        0x0c
      end

      def length
        7
      end

      def to_s
        "ClearAlarm #{timestamp_str} alarm_type:#{raw_type}"
      end

      def raw_type
        d(1)
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end
