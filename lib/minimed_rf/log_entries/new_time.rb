
module MinimedRF
  module PumpEvents
    class NewTime < Base
      def self.event_type_code
        0x18
      end

      def bytesize
        7
      end

      def to_s
        "NewTime #{timestamp_str}"
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end
