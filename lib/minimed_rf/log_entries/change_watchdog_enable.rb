# 7C00521B02070E
# 524,4/7/14,02:27:18,4/7/14 02:27:18,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,ChangeWatchdogEnable,"ENABLE=false, ACTION_REQUESTOR=pump",12753936686,53119959,92,MiniMed 530G - 551

# 7C01551B02070E
# 525,4/7/14,02:27:21,4/7/14 02:27:21,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,ChangeWatchdogEnable,"ENABLE=true, ACTION_REQUESTOR=pump",12753936685,53119959,91,MiniMed 530G - 551

module MinimedRF
  module PumpEvents
    class ChangeWatchdogEnable < Base
      def self.event_type_code
        0x7c
      end

      def bytesize
        7
      end

      def to_s
        "ChangeWatchdogEnable #{timestamp_str} enabled:#{enabled.inspect}"
      end

      def enabled
        ((d(1) & 0b1) == 1) ? true : false
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end
