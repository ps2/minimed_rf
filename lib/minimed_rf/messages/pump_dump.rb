
module MinimedRF
  class PumpDump < Message
    def self.bit_blocks
      {
        sequence: [1,7],
        x1: [15,6]
      }
    end

    def sequence
      b(:sequence)
    end

    def to_s
      "PumpDump: #{sequence}"
    end
  end
end
