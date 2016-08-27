
module MinimedRF
  module PumpEvents
    class SelectBasalProfile < Base
      def self.event_type_code
        0x14
      end

      def bytesize
        7
      end

      def to_s
        "SelectBasalProfile #{timestamp_str}"
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end
