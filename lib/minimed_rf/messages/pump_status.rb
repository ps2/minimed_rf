
module MinimedRF
  class PumpStatus < Message
    def self.bit_blocks
      {
        sequence: [1,7],
        trend: [12,3],
        pump_hour: [19,5],
        pump_minute: [26,6],
        pump_second: [34,6],
        pump_year: [40,8],
        pump_month: [52,4],
        pump_day: [59,5],
        bg_h: [72, 8],
        prev_bg_h: [80, 8],
        #field_x3: [94,1],
        insulin_remaining: [101,11],
        batt: [116,4],
        reservoir_days_remaining: [120, 8],  # "Days" + 1
        reservoir_minutes_remaining: [128, 16],  # "Minutes" only correlate with pump display during final 24 hours
        sensor_age: [144,8],
        sensor_remaining: [152,8],
        next_cal_hour: [160,8],  # ff at sensor end, 00 at sensor off
        next_cal_minute: [168,8],
        active_ins: [181, 11],
        prev_bg_l: [198, 1],
        bg_l: [199, 1],
        #field_x12: [201,7],
        sensor_hour: [227,5],
        sensor_minute: [234,6],
        sensor_year: [248, 8],
        sensor_month: [260, 4],
        sensor_day: [267,5]
      }
    end

    def pump_timestamp
      if b(:pump_year) > 0
        Time.new(b(:pump_year) + 2000, b(:pump_month), b(:pump_day), b(:pump_hour), b(:pump_minute), b(:pump_second))
      end
    end

    def sensor_timestamp
      if b(:sensor_year) > 0
        Time.new(b(:sensor_year) + 2000, b(:sensor_month), b(:sensor_day), b(:sensor_hour), b(:sensor_minute))
      end
    end

    def sequence
      b(:sequence)
    end

    def trend
      case b(:trend)
      when 0b000
        ""
      when 0b001
        "up"
      when 0b010
        "double up"
      when 0b011
        "down"
      when 0b100
        "double down"
      else
        "Unknown(#{b(:trend)})"
      end
    end

    def sensor_status
      case b(:bg_h)
      when 0
        :sensor_missing
      when 1
        :meter_bg_now
      when 2
        :weak_signal
      when 4
        :sensor_warmup
      when 7
        :high_bg # Above 400
      when 10
        :sensor_lost
      else
        :ok
      end
    end

    def active_insulin
      b(:active_ins) * 0.025
    end

    def parse_glucose(high, low)
      val = (high << 1) + low
      #val < 20 ? nil : val
    end

    def glucose
      parse_glucose(b(:bg_h), b(:bg_l))
    end

    def previous_glucose
      parse_glucose(b(:prev_bg_h), b(:prev_bg_l))
    end

    def sensor_age
      b(:sensor_age)
    end

    def sensor_remaining
      b(:sensor_remaining)
    end

    def insulin_remaining
      b(:insulin_remaining) / 10.0
    end

    def battery_pct
      (b(:batt) / 4.0 * 100).to_i
    end

    def to_s
      val = "PumpStatus: ##{sequence} #{pump_timestamp} #{sensor_timestamp} - "

      case sensor_status
      when :sensor_missing
        val << "Sensor missing"
      when :meter_bg_now
        val << "Meter BG Now - PreviousGlucose=#{previous_glucose} - SensorAge=#{sensor_age}hrs"
      when :weak_signal
        val << "Weak Signal - Glucose=#{glucose} PreviousGlucose=#{previous_glucose} - SensorAge=#{sensor_age}hrs"
      when :sensor_warmup
        val << "Sensor Warmup"
      when :sensor_lost
        val << "Sensor Lost"
      when :high_bg
        val << "BG Above 400"
      else
        val << "Glucose=#{glucose} PreviousGlucose=#{previous_glucose}"
      end

      unless trend.empty?
        val << " Trend=#{trend}"
      end

      val << " SensorAge=#{sensor_age}hrs- SensorRemaining=#{sensor_remaining} InsulinRemaining=#{insulin_remaining}U Battery=#{battery_pct}%"

      if active_insulin > 0
        val << " ActiveInsulin=#{active_insulin}"
      end
      val
    end
  end
end
