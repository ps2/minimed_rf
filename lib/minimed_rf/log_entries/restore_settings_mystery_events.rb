# These are events that were observed by selecting the User Settings -> Restore
# menu on 551 and 522 pumps, that I do not know the function of.  They do
# decode with valid dates, though, so I'm fairly sure that we're parsing
# at the correct byte boundaries.

module MinimedRF
  module PumpEvents
    class Unknown < Base
      def self.event_type_code
        0x52
      end

      def bytesize
        7
      end

      def to_s
        "Unknown #{timestamp_str}"
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end

module MinimedRF
  module PumpEvents
    class Unknown2 < Base
      def self.event_type_code
        0x51
      end

      def bytesize
        7
      end

      def to_s
        "Unknown2 #{timestamp_str}"
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end

# 5511a71d809c10000f0f00ffff00ffff00ffff00ffff00ffff00ffff00ffff000f0f00ffff00ffff00ffff00ffff00ffff00ffff00ffff56
module MinimedRF
  module PumpEvents
    class Unknown3 < Base
      def self.event_type_code
        0x55
      end

      def bytesize
        55
      end

      def to_s
        "Unknown3 #{timestamp_str}"
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end

# 54fca71d209c10fffcff00e65000ffff00ffff00ffff00ffff00ffff00ffff00fffffcfffcff00f05000ffff00ffff00ffff00ffff00ffff00ffff00ffff
module MinimedRF
  module PumpEvents
    class Unknown4 < Base
      def self.event_type_code
        0x54
      end

      def bytesize
        64
      end

      def to_s
        "Unknown4 #{timestamp_str}"
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end

module MinimedRF
  module PumpEvents
    class Unknown5 < Base
      def self.event_type_code
        0x1b
      end

      def bytesize
        7
      end

      def to_s
        "Unknown5 #{timestamp_str}"
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end

module MinimedRF
  module PumpEvents
    class Unknown6 < Base
      def self.event_type_code
        0x2d
      end

      def bytesize
        7
      end

      def to_s
        "Unknown6 #{timestamp_str}"
      end

      def timestamp
        parse_date(2)
      end

    end
  end
end
