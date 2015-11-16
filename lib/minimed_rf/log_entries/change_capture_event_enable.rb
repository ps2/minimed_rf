module MinimedRF
  module PumpEvents
    class ChangeCaptureEventEnable < Base

      # Got this from @bewest's decocare
      # https://github.com/bewest/decoding-carelink

      def self.event_type_code
        0x83
      end

      def length
        7
      end

      def to_s
        "ChangeCaptureEventEnable #{timestamp_str} enabled:#{enabled.inspect}"
      end

      def enabled
        ((d(1) & 0b1) == 1) ? true : false
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end
