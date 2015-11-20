
# 6541 5E1A02070E
# 522,4/7/14,02:26:30,4/7/14 02:26:30,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,ChangeReservoirWarningTime,"AMOUNT=28800000, ACTION_REQUESTOR=pump",12753936688,53119959,94,MiniMed 530G - 551

# 6524 641A02070E
# 523,4/7/14,02:26:36,4/7/14 02:26:36,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,ChangeReservoirWarningInsulin,"AMOUNT=9, ACTION_REQUESTOR=pump",12753936687,53119959,93,MiniMed 530G - 551

module MinimedRF
  module PumpEvents
    class ChangeReservoirWarningTime < Base

      def self.event_type_code
        0x65
      end

      def bytesize
        7
      end

      def to_s
        "ChangeReservoirWarningTime #{change_type_str} #{timestamp_str} amount:#{amount}"
      end

      def change_type
        d(1) & 0x11
      end

      def change_type_str
        {
          0 => "ChangeReservoirWarningTime",
          1 => "ChangeReservoirWarningInsulin"
        }[change_type]
      end

      def amount
        {
          0 => (d(1) >> 2),
          1 => (d(1) >> 2) * 1800000
        }[change_type]
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end
