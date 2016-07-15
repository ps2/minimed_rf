module MinimedRF
  module PumpEvents

    # Got this from @bewest's decocare
    # https://github.com/bewest/decoding-carelink

    class JournalEntryMealMarker < Base

      def self.event_type_code
        0x40
      end

      def bytesize
        9
      end

      def timestamp
        parse_date(2)
      end

      def to_s
        "JournalEntryMealMarker #{timestamp_str}"
      end

    end
  end
end
