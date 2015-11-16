module MinimedRF
  module PumpEvents
    class ChangeCarbUnits < Base

      def self.event_type_code
        0x6f
      end

      def length
        7
      end

      def timestamp
        parse_date(2)
      end

      def to_s
        "ChangeCarbUnits #{timestamp_str} "
      end

    end
  end
end
