
# 229,4/4/14,15:07:00,4/4/14 15:07:00,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,CalBGForGH,"AMOUNT=197, ORIGIN_TYPE=rf",12741001239,53115169,300,MiniMed 530G - 551
# 0a c5 40072f640e
# [10, 197, 64, 7, 47, 100, 14]
# xxxxxxxx xxxxxxxx MMxxxxxx MMxxxxxx ???xxxxx ???xxxxx xxxxxxxx
#      cmd      bgl seconds  minutes  hours    day      year
# 00001010 11000101 01000000 00000111 00101111 01100100 00001110

module MinimedRF
  module PumpEvents
    class CalBgForPh < Base

      def self.event_type_code
        0x0a
      end

      def length
        7
      end

      def to_s
        "CalBGForPH #{timestamp_str} BG:#{blood_glucose}"
      end

      def blood_glucose
        d(1) # TODO: Need high bits
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end
