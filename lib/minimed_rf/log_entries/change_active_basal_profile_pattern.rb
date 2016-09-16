# 1F20 763612030E

module MinimedRF
  module PumpEvents
    class ChangeActiveBasalProfilePattern < Base
      def self.event_type_code
        0x14
      end

      def bytesize
        7
      end

      def to_s
        "ChangeActiveBasalProfilePattern #{timestamp_str}"
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end
