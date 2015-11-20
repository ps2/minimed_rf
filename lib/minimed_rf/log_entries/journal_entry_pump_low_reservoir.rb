# 34c8006314080e

module MinimedRF
  module PumpEvents
    class JournalEntryPumpLowReservoir < Base
      def self.event_type_code
        0x34
      end

      def bytesize
        7
      end

      def to_s
        "JournalEntryPumpLowReservoir #{timestamp_str} Amount=#{amount}"
      end

      def amount
        d(1) / 10.0
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end
