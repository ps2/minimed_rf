
# 67 00 5B1902070E 001E
# 514,4/7/14,02:25:27,4/7/14 02:25:27,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,ChangeBolusReminderTime,"ALARM_TIME=1800000, ACTION_REQUESTOR=pump, START_TIME=0",12753936695,53119959,101,MiniMed 530G - 551

module MinimedRF
  module PumpEvents
    class ChangeBolusReminderTime < Base
      def self.event_type_code
        0x67
      end

      def bytesize
        9
      end

      def to_s
        "ChangeBolusReminderTime #{timestamp_str} ??? #{data_str}"
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end
