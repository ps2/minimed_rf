
module MinimedRF
  module PumpEvents
    class DeleteOtherDeviceID < Base
      def self.event_type_code
        0x82
      end

      def bytesize
        12
      end

      def device_id
        hex_str[18,6]
      end

      def to_s
        "DeleteOtherDeviceID #{timestamp_str} #{device_id}"
      end

      def timestamp
        parse_date(2)
      end

      def as_json
        super.merge({
          device_id: device_id
        })
      end

    end
  end
end
