
module MinimedRF
  class PumpStatus < Message
    def self.bit_blocks
      {
        sequence: [1,7],
        minute: [234,6],
        hour: [227,5],
        day: [267,5],
        month: [260, 4],
        year: [248, 8],
        bg_h: [72, 8],
        bg_l: [199, 1],
        prev_bg_h: [80, 8],
        prev_bg_l: [198, 1]
      }
    end

    def timestamp
      if b(:year) > 0
        Time.new(b(:year) + 2000, b(:month), b(:day), b(:hour), b(:minute))
      end
    end

    def sequence
      b(:sequence)
    end

    def sensor_status
      case b(:bg_h)
      when 0
        :sensor_missing
      when 1
        :meter_bg_now
      when 2
        :weak_signal
      else
        :ok
      end
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

    def to_s
      "PumpStatus: ##{sequence} #{timestamp} - Glucose=#{glucose} PreviousGlucose=#{previous_glucose}"
    end
  end
end
