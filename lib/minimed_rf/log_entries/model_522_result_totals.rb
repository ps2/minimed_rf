module MinimedRF
  module PumpEvents

    # Got this from @bewest's decocare
    # https://github.com/bewest/decoding-carelink/blob/master/decocare/history.py

    class Model522ResultTotals < Base

      def self.event_type_code
        0x6d
      end

      def length
        44
      end

      def timestamp
        parse_date_2byte(2)
      end

      def to_s
        "Model522ResultTotals #{timestamp_str}"
      end

    end
  end
end
