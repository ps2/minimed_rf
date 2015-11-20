# 60 00 471902070E
# 512,4/7/14,02:25:07,4/7/14 02:25:07,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,ChangeBGReminderEnable,"ENABLE=false, ACTION_REQUESTOR=pump",12753936697,53119959,103,MiniMed 530G - 551

module MinimedRF
  module PumpEvents
    class ChangeBGReminderEnable < Base
      def self.event_type_code
        0x60
      end

      def bytesize
        7
      end

      def to_s
        "ChangeBGReminderEnable #{timestamp_str} enable:#{enable}"
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
