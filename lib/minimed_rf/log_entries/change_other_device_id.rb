
module MinimedRF
  module PumpEvents
    class ChangeOtherDeviceID < Base
      def self.event_type_code
        0x7d
      end

      def bytesize
        37
      end

      def to_s
        "ChangeOtherDeviceID #{timestamp_str}"
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end
