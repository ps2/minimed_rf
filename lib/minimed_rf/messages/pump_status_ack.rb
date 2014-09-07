
module MinimedRF
  class PumpStatusAck < Message
    def self.bit_blocks
      {
        sequence: [1,7],
      }
    end

    def sequence
      b(:sequence)
    end

    def to_s
      "PumpStatusAck: #{sequence}"
    end
  end
end
