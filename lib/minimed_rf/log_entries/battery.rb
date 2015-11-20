module MinimedRF
  module PumpEvents

    # Got this from @bewest's decocare
    # https://github.com/bewest/decoding-carelink/blob/master/decocare/history.py

    class Battery < Base

      def self.event_type_code
        0x1a
      end

      def bytesize
        7
      end

      def timestamp
        parse_date(2)
      end

      def to_s
        "Battery #{timestamp_str}"
      end

    end
  end
end
