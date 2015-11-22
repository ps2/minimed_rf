require 'date'

module MinimedRF
  module PumpEvents
    class ResultDailyTotal < Base

      def self.event_type_code
        0x07
      end

      def bytesize
        if @pump_model.larger
          10
        else
          7
        end
      end

      def to_s
        "ResultDailyTotal #{timestamp_str}"  # TODO: figure out what this contains
      end

      def valid_date
        year, month, day = parse_date_2byte(5)
        Date.new(year, month, day)
      end

      def valid_date_str
        d = valid_date
        sprintf("%04d-%02d-%02d", d.year, d.month, d.day)
      end

      def timestamp
        midnight = valid_date+1
        [midnight.year, midnight.month, midnight.day, 0, 0, 0]
      end

      def as_json
        super.merge({
          valid_date: valid_date_str
        })
      end
    end
  end
end
