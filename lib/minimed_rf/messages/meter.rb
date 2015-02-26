module MinimedRF
  class Meter < Message

    # a5c527ad008e61
    def self.bit_blocks
      {
        glucose_h: [0,8],
        glucose_l: [8,8]
      }
    end

    def glucose
      (b(:glucose_h) << 8) + b(:glucose_l)
    end

    def broadcast_address
      hex_str[2,6]
    end

    def to_s
      "Meter: #{glucose}"
    end
  end
end
