
module MinimedRF
  module PumpEvents
    class ChangeMaxBasal < Base
      def self.event_type_code
        0x2c
      end

      def bytesize
        7
      end

      def max_basal
        d(1) / 40.0
      end

      def to_s
        "ChangeMaxBasal #{max_basal} #{timestamp_str}"
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end
