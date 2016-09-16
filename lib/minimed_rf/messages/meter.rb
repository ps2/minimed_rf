module MinimedRF
  class Meter < Message

    # a5c527ad008e61
    def self.bit_blocks
      {
        flags: [37,2],
        glucose: [39,9]
      }
    end

    def glucose
      b(:glucose)
      #(b(:glucose_h) << 8) + b(:glucose_l)
    end

    def meter_id
      hex_str[2,6]
    end

    def flags
      case b(:flags)
      when 3
        "Ack"
      end
    end

    def is_ack?
      return b(:flags) == 3
    end

    def to_s
      if flags
        "Meter id:#{meter_id} #{flags} raw:#{@data.unpack("H*")}"
      else
        "Meter id:#{meter_id} BG:#{glucose}"
      end
    end
  end
end
