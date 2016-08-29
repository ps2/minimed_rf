module MinimedRF
  module PumpEvents
    class EnableBolusWizard < Base
      def self.event_type_code
        0x2d
      end

      def bytesize
        7
      end

      def to_s
        "EnableBolusWizard #{timestamp_str}"
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end
