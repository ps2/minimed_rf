# 06 67 01 6E 773BB1880E
# 288,4/8/14,17:59:55,4/8/14 17:59:55,,,,,,,,,,,,,,,,,,,,,,,,,Device Alarm (103),,,,,AlarmPump,"RAW_TYPE=103, RAW_MODULE=44, LINE_NUM=366",12772625734,53126704,105,MiniMed 530G - 551

module MinimedRF
  module PumpEvents
    class AlarmPump < Base

      def self.event_type_code
        0x06
      end

      def length
        9
      end

      def to_s
        "AlarmPump #{timestamp_str} raw_type:#{raw_type}"
      end

      def raw_type
        d(1)
      end

      def timestamp
        parse_date(4)
      end

    end
  end
end
