module MinimedRF
  module PumpEvents

    class DailyTotal515 < Base

      def self.event_type_code
        0x6c
      end

      def bytesize
        38
      end

      def timestamp
        parse_date_2byte(1)
      end

      def to_s
        "DailyTotal515 #{timestamp_str}"
      end

    end

    class DailyTotal522 < Base

      def self.event_type_code
        0x6d
      end

      def bytesize
        44
      end

      def timestamp
        parse_date_2byte(2)
      end

      def to_s
        "DailyTotal522 #{timestamp_str}"
      end

    end


    class DailyTotal523 < Base

      def self.event_type_code
        0x6e
      end

      def bytesize
        52
      end

      def valid_date
        year, month, day = parse_date_2byte(1)
        if year > 0 && month > 0 && day > 0
          Date.new(year, month, day)
        end
      end

      def valid_date_str
        if valid_date
          d = valid_date
          sprintf("%04d-%02d-%02d", d.year, d.month, d.day)
        end
      end

      def timestamp
        if valid_date
          midnight = valid_date+1
          [midnight.year, midnight.month, midnight.day, 0, 0, 0]
        end
      end

      def as_json
        super.merge({
          valid_date: valid_date_str
        })
      end

      def to_s
        "DailyTotal523 #{timestamp_str}"
      end

    end

  end
end
