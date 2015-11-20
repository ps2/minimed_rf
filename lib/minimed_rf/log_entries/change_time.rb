# 1700 234E17040E 1800004E170110

# 775,1/4/14,23:14:00,1/4/14 23:14:00,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,ChangeTimeGH,NEW_TIME=1451690040000,12073459554,52854662,83,MiniMed 530G - 551
# 777,1/4/14,23:14:35,1/4/14 23:14:35,1/1/16 23:14:00,,,,,,,,,,,,,,,,,,,,,,,,,,,,,ChangeTime,"NEW_TIME=1451690040000, ACTION_REQUESTOR=pump",12073459546,52854662,75,MiniMed 530G - 551

module MinimedRF
  module PumpEvents
    class ChangeTime < Base

      def self.event_type_code
        0x17
      end

      def bytesize
        14
      end

      def to_s
        "ChangeTime #{timestamp_str}" # TODO: decode new time
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end
