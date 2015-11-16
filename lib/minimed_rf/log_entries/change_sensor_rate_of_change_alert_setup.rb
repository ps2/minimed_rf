module MinimedRF
  module PumpEvents
    class ChangeSensorRateOfChangeAlertSetup < Base

      def self.event_type_code
        0x56
      end

      def length
        12
      end

      def timestamp
        parse_date(2)
      end

      def to_s
        "ChangeSensorRateOfChangeAlertSetup #{timestamp_str} "
      end

    end
  end
end
