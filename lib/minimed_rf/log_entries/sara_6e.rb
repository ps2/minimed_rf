module MinimedRF
  module PumpEvents

    # Got this from @bewest's decocare
    # https://github.com/bewest/decoding-carelink/blob/master/decocare/history.py#L673-L684

    class Sara6E < Base

      def self.event_type_code
        0x6e
      end

      def bytesize
        52
      end

      def timestamp
        parse_date_2byte(1)
      end

      def to_s
        "Sara6E #{timestamp_str}"
      end

    end
  end
end
