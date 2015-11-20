module MinimedRF
  module PumpEvents

    class JournalEntryPumpLowBattery < Base

      def self.event_type_code
        0x19
      end

      def bytesize
        7
      end

      def timestamp
        parse_date(2)
      end

      def to_s
        "JournalEntryPumpLowBattery #{timestamp_str}"
      end

    end
  end
end
