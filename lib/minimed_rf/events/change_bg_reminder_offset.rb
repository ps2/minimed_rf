
module MinimedRF
  module PumpEvents
    class ChangeBGReminderOffset < Base
      def self.event_type_code
        0x31
      end

      def length
        7
      end

      def to_s
        "ChangeBGReminderOffset #{timestamp_str} Amount=#{amount}"
      end

      def amount
        d(1)  # TODO: decode this
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end
