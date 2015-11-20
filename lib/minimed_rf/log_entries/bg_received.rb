# 3f 18 4007af640e c5 27ad
# xxxxxxxx xxxxxxxx ??xxxxxx ??xxxxxx BGLxxxxx ???xxxxx xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx
#      cmd      bgh seconds  minutes  hours    day      year     meterid  meterid  meterid
# 00111111 00011000 01000000 00000111 10101111 01100100 00001110 11000101 00100111 10101101
# 231,4/4/14,15:07:00,4/4/14 15:07:00,,197,#C527AD,,,,,,,,,,,,,,,,,,,,,,,,,,,BGReceived,"AMOUNT=197, ACTION_REQUESTOR=paradigm link or b key, PARADIGM_LINK_ID=C527AD",12741001048,53115169,109,MiniMed 530G - 551


module MinimedRF
  module PumpEvents
    class BGReceived < Base

      def self.event_type_code
        0x3f
      end

      def bytesize
        10
      end

      def to_s
        "BGReceived #{timestamp_str} BG:#{amount} METER:#{paradigm_link_id}"
      end

      def amount
        (d(1) << 3) + (d(4) >> 5)
      end

      def paradigm_link_id
        @data.byteslice(7,3).unpack("H*").first
      end

      def timestamp
        parse_date(2)
      end

      def as_json
        super.merge({
          amount: amount,
          link: paradigm_link_id,
        })
      end
    end
  end
end
