# 57 32 721802070E
# 510,4/7/14,02:24:50,4/7/14 02:24:50,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,ChangeBolusScrollStepSize,"STEP_SIZE=step_0_point_05, ACTION_REQUESTOR=pump",12753936699,53119959,105,MiniMed 530G - 551

# 57 64 761802070E
# 511,4/7/14,02:24:54,4/7/14 02:24:54,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,ChangeBolusScrollStepSize,"STEP_SIZE=step_0_point_1, ACTION_REQUESTOR=pump",12753936698,53119959,104,MiniMed 530G - 551

module MinimedRF
  module PumpEvents
    class ChangeBolusScrollStepSize < Base
      def self.event_type_code
        0x57
      end

      def length
        7
      end

      def to_s
        "ChangeBolusScrollStepSize #{timestamp_str} stepsize=#{amount}"
      end

      def amount
        d(1) / 1000.0
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end
