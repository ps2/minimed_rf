
module MinimedRF
  module PumpEvents
    class SelfTest < Base
      def self.event_type_code
        0x20
      end

      def bytesize
        7
      end

      def to_s
        "SelfTest #{timestamp_str}"
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end
