module MinimedRF
  module PumpEvents
    class SetAutoOff < Base
      def self.event_type_code
        0x1b
      end

      def bytesize
        7
      end

      def to_s
        "SetAutoOff #{timestamp_str}"
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end
