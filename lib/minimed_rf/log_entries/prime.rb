# 0300000022 C21736170D
#[2013, 12, 23, 22, 23, 2]

module MinimedRF
  module PumpEvents
    class Prime < Base
      def self.event_type_code
        0x03
      end

      def bytesize
        10
      end

      def to_s
        "Prime #{timestamp_str} Amount:#{amount} PrimeType:#{prime_type}"
      end

      def prime_type
        {
          0 => "Manual",
          3 => "Fixed"
        }[d(2)]
      end

      def amount
        (d(4) << 2) / 40.0
      end

      def timestamp
        parse_date(5)
      end

    end
  end
end
