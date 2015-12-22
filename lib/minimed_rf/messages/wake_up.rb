module MinimedRF
  class WakeUp < Message

    # a7 350535 5d 00 48
    def self.bit_blocks
      {
      }
    end

    def to_s
      "WakeUp"
    end
  end
end
