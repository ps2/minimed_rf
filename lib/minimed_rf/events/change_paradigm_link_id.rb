# 3c012b7016080e3dc228060000003e000000000000

module MinimedRF
  module PumpEvents
    class ChangeParadigmLinkID < Base

      def self.event_type_code
        0x3c
      end

      def length
        21
      end

      def timestamp
        parse_date(2)
      end

      def link1
        @data.byteslice(8,3).unpack("H*").first
      end

      def link2
        @data.byteslice(11,3).unpack("H*").first
      end

      def link3
        @data.byteslice(15,3).unpack("H*").first
      end

      def to_s
        "ChangeParadigmLinkID #{timestamp_str} link1:#{link1} link2:#{link2} link3:#{link3}"
      end

    end
  end
end
