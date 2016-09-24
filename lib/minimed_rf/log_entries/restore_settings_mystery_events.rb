# These are events that were observed by selecting the User Settings -> Restore
# menu on 551 and 522 pumps, that I do not know the function of.  They do
# decode with valid dates, though, so I'm fairly sure that we're parsing
# at the correct byte boundaries.

module MinimedRF
  module PumpEvents
    class RestoreMystery2b < Base
      def self.event_type_code
        0x2b
      end

      def bytesize
        7
      end

      def to_s
        "RestoreMystery2b #{timestamp_str}"
      end

      def timestamp
        parse_date(2)
      end

    end

    class RestoreMystery51 < Base
      def self.event_type_code
        0x51
      end

      def bytesize
        7
      end

      def to_s
        "RestoreMystery51 #{timestamp_str}"
      end

      def timestamp
        parse_date(2)
      end

    end

    class RestoreMystery52 < Base
      def self.event_type_code
        0x52
      end

      def bytesize
        7
      end

      def to_s
        "RestoreMystery52 #{timestamp_str}"
      end

      def timestamp
        parse_date(2)
      end

    end

    class RestoreMystery53 < Base
      def self.event_type_code
        0x53
      end

      def bytesize
        7
      end

      def to_s
        "RestoreMystery53 #{timestamp_str}"
      end

      def timestamp
        parse_date(2)
      end

    end

    # 54fca71d209c10fffcff00e65000ffff00ffff00ffff00ffff00ffff00ffff00fffffcfffcff00f05000ffff00ffff00ffff00ffff00ffff00ffff00ffff
    class RestoreMystery54 < Base
      def self.event_type_code
        0x54
      end

      def bytesize
        64
      end

      def to_s
        "RestoreMystery54 #{timestamp_str}"
      end

      def timestamp
        parse_date(2)
      end

    end

    # 5511a71d809c10000f0f00ffff00ffff00ffff00ffff00ffff00ffff00ffff000f0f00ffff00ffff00ffff00ffff00ffff00ffff00ffff56
    class RestoreMystery55 < Base
      def self.event_type_code
        0x55
      end

      def bytesize
        55
      end

      def to_s
        "RestoreMystery55 #{timestamp_str}"
      end

      def timestamp
        parse_date(2)
      end

    end

    class RestoreMystery69 < Base
      def self.event_type_code
        0x69
      end

      def bytesize
        if @pump_model.larger
          9
        else
          7
        end
      end

      def to_s
        "RestoreMystery69 #{timestamp_str}"
      end

      def timestamp
        parse_date(2)
      end

    end

  end
end
