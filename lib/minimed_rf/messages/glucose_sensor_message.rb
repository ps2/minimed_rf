require 'colorize'

module MinimedRF
  class GlucoseSensorMessage < Message
    def bit_blocks
      {
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

    def glucose
      (b(:bg_h) << 1) + b(:bg_l)
    end

    def previous_glucose
      (b(:prev_bg_h) << 1) + b(:prev_bg_l)
    end

    def to_s
      "GlucoseSensorMessage: #{timestamp} - Glucose=#{glucose} PreviousGlucose=#{previous_glucose}"
    end
  end
end
