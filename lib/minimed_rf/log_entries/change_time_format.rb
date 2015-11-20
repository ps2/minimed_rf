# 64000D4E17040E
# 776,1/4/14,23:14:13,1/4/14 23:14:13,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,ChangeTimeDisplayFormat,"FORMAT=d12, ACTION_REQUESTOR=pump",12073459547,52854662,76,MiniMed 530G - 551

module MinimedRF
  module PumpEvents
    class ChangeTimeFormat < Base

      def self.event_type_code
        0x64
      end

      def bytesize
        7
      end

      def to_s
        "ChangeTimeFormat #{timestamp_str} format:#{format}"
      end

      def format
        {
          # TODO: other formats
          0 => "d12"
        }[d(1)]
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end
