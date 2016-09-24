module MinimedRF
  module PumpEvents

    class BolusReminder < Base
      def self.event_type_code
        0x69
      end

      def bytesize
        if @pump_model.larger
          9
        else
          7
        end
      end

      def to_s
        "BolusReminder #{timestamp_str}"
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end
