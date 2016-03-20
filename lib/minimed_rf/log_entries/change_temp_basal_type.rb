
# 5F05 473817030E - enabale
# 5F04 6D3817030E - disable


module MinimedRF
  module PumpEvents
    class ChangeTempBasalType < Base
      def self.event_type_code
        0x62
      end

      def bytesize
        7
      end

      def to_s
        "ChangeTempBasalType #{timestamp_str} type:#{enabled.inspect} "
      end

      def enabled
        d(1) == 1 ? "percent" : "absolute"
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end
