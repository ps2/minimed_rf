# 1F20 763612030E

module MinimedRF
  module PumpEvents
    class SaveSettings < Base
      def self.event_type_code
        0x5d
      end

      def bytesize
        7
      end

      def to_s
        "SaveSettings #{timestamp_str}"
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end
