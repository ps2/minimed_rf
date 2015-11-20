# 0B 73 006F3532A40E - [2014, 4, 4, 18, 53, 47]

# 297,4/4/14,18:53:47,4/4/14 18:53:47,,,,,,,,,,,,,,,,,,,,,,,,,Sensor Alert: Low Glucose Predicted (115),,,,,AlarmSensor,"ALARM_TYPE=115, AMOUNT=0, ACTION_REQUESTOR=sensor",12741001030,53115169,91,MiniMed 530G - 551


module MinimedRF
  module PumpEvents
    class AlarmSensor < Base

      class Record
        attr_accessor :amount, :age
        def to_s
          "Amount:#{amount} Age:#{age}"
        end
      end

      def self.event_type_code
        0x0b
      end

      def bytesize
        8
      end


      def to_s
        "AlarmSensor #{timestamp_str} #{alarm_type_str} amount:#{amount}"
      end

      def alarm_types
        {
          101 => "High Glucose",
          102 => "Low Glucose",
          104 => "Meter BG Now",
          105 => "Cal Reminder",
          106 => "Calibration Error",
          107 => "Sensor End",
          112 => "Weak Signal",
          113 => "Lost Sensor",
          114 => "High Glucose Predicted",
          115 => "Low Glucose Predicted"
        }
      end

      def alarm_type_str
        alarm_types[alarm_type] || alarm_type.to_s
      end

      def alarm_type
        d(1)
      end

      def amount
        d(2)
      end

      def timestamp
        parse_date(3)
      end

      def profile_index
        d(1)
      end

      def as_json
        r = super.merge({
          alarm_description: alarm_type_str,
          alarm_type: alarm_type
        })
        if amount > 0
          r[:amount] = amount
        end
        r
      end

    end
  end
end
