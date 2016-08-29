
module MinimedRF
  module PumpEvents
    class ChangeBolusWizardSetup < Base
      def self.event_type_code
        0x4f
      end

      def bytesize
        39
      end

      def to_s
        "ChangeBolusWizardSetup #{timestamp_str}"
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end
