
module MinimedRF
  class PumpStatusAck < Message
    def self.bit_blocks
      {
        flag: [0,1],
        sequence: [1,7],
        response_type: [40,8],
      }
    end

    def sequence
      b(:sequence)
    end

    def device_address
      hex_str[2,6]
    end

    def response_type
      if @data.length > 5
        b(:response_type)
      else
        0
      end
    end

    def to_s
      if @data.length > 2
        "PumpStatusAck: #{b(:flag)} ##{sequence} #{device_address} #{response_type}"
      else
        "PumpStatusAck: #{b(:flag)} ##{sequence}"
      end
    end
  end
end
