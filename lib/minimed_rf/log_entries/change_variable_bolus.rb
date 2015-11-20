# 5E 01 540A11030E
# 3672,4/3/14,17:10:20,4/3/14 17:10:20,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,ChangeVariableBolusEnable,"ENABLE=true, ACTION_REQUESTOR=pump",12753297208,53119725,316,MiniMed 530G - 551

# 5E 00 693817030E
# 3805,4/3/14,23:56:41,4/3/14 23:56:41,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,ChangeVariableBolusEnable,"ENABLE=false, ACTION_REQUESTOR=pump",12753297170,53119725,278,MiniMed 530G - 551


module MinimedRF
  module PumpEvents
    class ChangeVariableBolus < Base
      def self.event_type_code
        0x5e
      end

      def bytesize
        7
      end

      def to_s
        "ChangeVariableBolus #{timestamp_str} enabled:#{enabled.inspect}"
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
