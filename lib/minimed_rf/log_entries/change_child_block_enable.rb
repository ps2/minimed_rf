# 2301731B02070E
#526,4/7/14,02:27:51,4/7/14 02:27:51,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,ChangeChildBlockEnable,"ENABLE=true, ACTION_REQUESTOR=pump",12753936684,53119959,90,MiniMed 530G - 551

# 2300411C02070E
#527,4/7/14,02:28:01,4/7/14 02:28:01,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,ChangeChildBlockEnable,"ENABLE=false, ACTION_REQUESTOR=pump",12753936683,53119959,89,MiniMed 530G - 551

module MinimedRF
  module PumpEvents
    class ChangeChildBlockEnable < Base
      def self.event_type_code
        0x23
      end

      def bytesize
        7
      end

      def to_s
        "ChangeChildBlockEnable #{timestamp_str} enabled:#{enabled.inspect}"
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
