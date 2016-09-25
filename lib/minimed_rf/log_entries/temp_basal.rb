# 33 3C 460615060E 081614 460615060E
# 301,4/6/14,21:06:06,4/6/14 21:06:06,,,,60,Percent,10:00:00,,,,,,,,,,,,,,,,,,,,,,,,ChangeTempBasalPercent,"PERCENT_OF_RATE=60, DURATION=36000000, ACTION_REQUESTOR=pump",12753293982,53119725,90,MiniMed 530G - 551

# 33 46 533414050e 081618 533414050e
# 700,4/5/14,20:52:19,4/5/14 20:52:19,,,,70,Percent,12:00:00,,,,,,,,,,,,,,,,,,,,,,,,ChangeTempBasalPercent,"PERCENT_OF_RATE=70, DURATION=43200000, ACTION_REQUESTOR=pump",12753297028,53119725,136,MiniMed 530G - 551


module MinimedRF
  module PumpEvents
    class TempBasal < Base

      def self.event_type_code
        0x33
      end

      def bytesize
        8
      end

      def timestamp
        parse_date(2)
      end

      def rate_type
        (d(7) >> 3) == 0 ? 'absolute' : 'percent'
      end

      def rate
        if rate_type == 'absolute'
          (((d(7) & 0b111) << 8) + d(1)) / 40.0
        else
          d(1)
        end
      end

      def to_s
        "TempBasal #{timestamp_str} rate_type:#{rate_type} rate:#{rate}"
      end

      def as_json
        super.merge({
          rate: rate,
          temp: rate_type
        })
      end

    end
  end
end
