# 7B04 400010040E 200B00
# 250,4/4/14,16:00:00,4/4/14 16:00:00,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,BasalProfileStart,
# "PATTERN_NAME=standard, PROFILE_INDEX=4, RATE=0.275, START_TIME=57600000, ACTION_REQUESTOR=pump",12741001041,53115169,102,MiniMed 530G - 551


# 7B05 400015040E 2A0C00
# 420,4/4/14,21:00:00,4/4/14 21:00:00,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,BasalProfileStart,
# "PATTERN_NAME=standard, PROFILE_INDEX=5, RATE=0.3, START_TIME=75600000, ACTION_REQUESTOR=pump",12741001901,53115170,86,MiniMed 530G - 551


module MinimedRF
  module PumpEvents
    class BasalProfileStart < Base

      def self.event_type_code
        0x7b
      end

      def length
        10
      end

      def to_s
        "BasalProfileStart #{timestamp_str} #{profile_index} rate:#{rate}"
      end

      def timestamp
        parse_date(2)
      end

      def rate
        d(8) / 40.0  # TODO: get high bits
      end

      def profile_index
        d(1)
      end

    end
  end
end
