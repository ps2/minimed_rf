# 5F05 473817030E - enabale
# 5F04 6D3817030E - disable


module MinimedRF
  module PumpEvents
    class ChangeAudioBolus < Base
      def self.event_type_code
        0x5f
      end

      def length
        7
      end

      def to_s
        "ChangeAudioBolus #{timestamp_str} enabled:#{enabled.inspect} stepsize:#{stepsize}"
      end

      def enabled
        ((d(1) & 0b1) == 1) ? true : false
      end

      def stepsize
        (d(1) >> 1) / 20.0
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end
