# 33 3C 460615060E 081614 460615060E
# 301,4/6/14,21:06:06,4/6/14 21:06:06,,,,60,Percent,10:00:00,,,,,,,,,,,,,,,,,,,,,,,,ChangeTempBasalPercent,"PERCENT_OF_RATE=60, DURATION=36000000, ACTION_REQUESTOR=pump",12753293982,53119725,90,MiniMed 530G - 551

# 33 46 533414050e 081618 533414050e
# 700,4/5/14,20:52:19,4/5/14 20:52:19,,,,70,Percent,12:00:00,,,,,,,,,,,,,,,,,,,,,,,,ChangeTempBasalPercent,"PERCENT_OF_RATE=70, DURATION=43200000, ACTION_REQUESTOR=pump",12753297028,53119725,136,MiniMed 530G - 551


module MinimedRF
  module PumpEvents
    class TempBasalDuration < Base

      def self.event_type_code
        0x16
      end

      def bytesize
        7
      end

      def timestamp
        parse_date(2)
      end

      def duration
        d(1) * 30
      end

      def to_s
        "TempBasalDuration #{timestamp_str} duration:#{duration}"
      end

      def as_json
        super.merge({
          duration: duration,
        })
      end

    end
  end
end
