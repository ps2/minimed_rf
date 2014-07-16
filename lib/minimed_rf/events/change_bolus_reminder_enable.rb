# 6601 5B1902070E
# 515,4/7/14,02:25:27,4/7/14 02:25:27,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,ChangeBolusReminderEnable,"ENABLE=true, ACTION_REQUESTOR=pump",12753936694,53119959,100,MiniMed 530G - 551
# 6600 5e1902070e
# 516,4/7/14,02:25:30,4/7/14 02:25:30,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,ChangeBolusReminderEnable,"ENABLE=false, ACTION_REQUESTOR=pump",12753936692,53119959,98,MiniMed 530G - 551

module MinimedRF
  module PumpEvents
    class ChangeBolusReminderEnable < Base
      def self.event_type_code
        0x66
      end

      def length
        7
      end

      def to_s
        "ChangeBolusReminderEnable #{timestamp_str} enable:#{enable}"
      end

      def enable
        d(1) == 0 ? false : true
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end
