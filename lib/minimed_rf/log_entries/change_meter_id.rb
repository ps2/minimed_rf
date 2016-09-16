# 3601ad481208103701b20700000038000000000000

module MinimedRF
  module PumpEvents
    class ChangeMeterId < Base

      def self.event_type_code
        0x36
      end

      def bytesize
        21
      end

      def timestamp
        parse_date(2)
      end

      def meter_id_at(pos)
        bytes = @data.byteslice(pos,3)
        (bytes.getbyte(0) << 16) + (bytes.getbyte(1) << 8) + bytes.getbyte(2)
      end

      def link1
        meter_id_at(8)
      end

      def link2
        meter_id_at(11)
      end

      def link3
        meter_id_at(15)
      end

      def to_s
        "ChangeMeterId #{timestamp_str} link1:#{link1} link2:#{link2} link3:#{link3}"
        #{}"ChangeMeterId #{timestamp_str} link1:#{link1} link2:#{link2} link3:#{link3}"
      end

    end
  end
end
