module MinimedRF
  module PumpEvents

    # Got this from @bewest's decocare
    # https://github.com/bewest/decoding-carelink

    class EnableDisableRemote < Base

      def self.event_type_code
        0x26
      end

      def bytesize
        21
      end

      def timestamp
        parse_date(2)
      end

      def enabled
        ((d(1) & 0b1) == 1) ? true : false
      end

      def to_s
        "EnableDisableRemote #{timestamp_str} enabled=#{enabled.inspect}"
      end

    end
  end
end
