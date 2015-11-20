module MinimedRF
  module PumpEvents

    # Got this from @bewest's decocare
    # https://github.com/bewest/decoding-carelink

    class JournalEntryExerciseMarker < Base

      def self.event_type_code
        0x41
      end

      def bytesize
        8
      end

      def timestamp
        parse_date(2)
      end

      def to_s
        "JournalEntryExerciseMarker #{timestamp_str}"
      end

    end
  end
end
