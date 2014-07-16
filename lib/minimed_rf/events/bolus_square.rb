module MinimedRF
  module PumpEvents
    class BolusSquare < Base

      def self.event_type_code
        0x5e
      end

      def length
        21
      end

      def insulin_decode(a, b)
        ((a << 8) + b) / 40.0
      end

      def amount
        insulin_decode(d(1), d(2))
      end

      def to_s
        "BolusSquare #{timestamp_str} #{amount} #{programmed_amount} #{unabsorbed_insulin_total} #{data_str}"
      end

      def timestamp
        parse_date(9)
      end

      def programmed_amount
        insulin_decode(d(3), d(4))
      end

      def unabsorbed_insulin_total
        insulin_decode(d(5), d(6))
      end

    end
  end
end
