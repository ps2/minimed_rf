
module MinimedRF

  AlertCodes = {
    0x04 => :no_delivery,
    0x33 => :max_hourly_bolus,
    0x52 => :low_reservoir,
    0x65 => :high_glucose,
    0x66 => :low_glucose,
    0x68 => :meter_bg_now,
    0x69 => :meter_bg_soon,
    0x6a => :calibration_error,
    0x6b => :sensor_end,
    0x70 => :weak_signal,
    0x71 => :lost_sensor,
    0x72 => :high_predicted,
    0x73 => :low_predicted,
  }

  class Alert < Message

    # Max hourly bolus
    # 2014-09-08T22:01:09-0500 - a2 350535 01 e3 33 153b1d 0e 09 08 5200 d8

    def self.bit_blocks
      {
        sequence: [1,7],
        alert_type: [8,8],
        alert_hour: [19,5],
        alert_minute: [26,6],
        alert_second: [34,6],
        alert_year: [40,8],
        alert_month: [52,4],
        alert_day: [59,5],
      }
    end

    def sequence
      b(:sequence)
    end

    def alert_type
      AlertCodes[b(:alert_type)]
    end

    def timestamp
      if b(:alert_year) > 0
        Time.new(b(:alert_year) + 2000, b(:alert_month), b(:alert_day), b(:alert_hour), b(:alert_minute), b(:alert_second))
      end
    end

    def alert_type_str
      case alert_type
      when :max_hourly_bolus
        "Max Hourly Bolus"
      when :high_predicted
        "High Predicted"
      when :meter_bg_now
        "Meter BG Now"
      else
        "Unknown(#{b(:alert_type)})"
      end
    end

    def to_s
      "Alert: #{timestamp} ##{sequence} \"#{alert_type_str}\""
    end
  end
end
