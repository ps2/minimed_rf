
# 68005E1902070E001E
# 517,4/7/14,02:25:30,4/7/14 02:25:30,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,DeleteBolusReminderTime,"ALARM_TIME=1800000, ACTION_REQUESTOR=pump, START_TIME=0",12753936693,53119959,99,MiniMed 530G - 551

module MinimedRF
  module PumpEvents
    class DeleteBolusReminderTime < Base

      def self.event_type_code
        0x68
      end

      def bytesize
        9
      end

      def to_s
        "DeleteBolusReminderTime #{timestamp_str} alarm_time:#{alarm_time} start_time:#{start_time}"
      end

      def alarm_time
        d(8) * 6000
      end

      def start_time
        d(7) * 6000
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end
