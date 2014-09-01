require 'colorize'

module MinimedRF
  class GlucoseSensorMessage < Message
    def self.bit_blocks
      {
        sequence: [0,8],
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
      Time.new(b(:year) + 2000, b(:month), b(:day), b(:hour), b(:minute))
    end

    def sequence
      b(:sequence)
    end

    def parse_glucose(high, low)
      val = (high << 1) + low
      val < 20 ? nil : val
    end

    def glucose
      parse_glucose(b(:bg_h), b(:bg_l))
    end

    def previous_glucose
      parse_glucose(b(:prev_bg_h), b(:prev_bg_l))
    end

    def to_s
      "GlucoseSensorMessage: #{sequence} #{timestamp} - Glucose=#{glucose} PreviousGlucose=#{previous_glucose}"
    end
  end
end
