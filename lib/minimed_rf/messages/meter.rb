module MinimedRF
  class Meter < Message

    # a5c527ad008e61
    def self.bit_blocks
      {
        alert: [5,2],
        glucose: [7,9]
      }
    end

    def glucose
      b(:glucose)
      #(b(:glucose_h) << 8) + b(:glucose_l)
    end

    def alert
      case b(:alert)
      when 3
        "BG High"
      end
    end

    def to_s
      if alert
        "Meter: Alert - #{alert}"
      else
        "Meter: #{glucose}"
      end
    end
  end
end
