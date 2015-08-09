
module MinimedRF
  class DeviceTest < Message

    # a2350535034fb4
    def self.bit_blocks
      {
        sequence: [0,8]
      }
    end

    def sequence
      b(:sequence)
    end

    def device_address
      hex_str[2,6]
    end

    def to_s
      "DeviceTest: ##{sequence} #{device_address}"
    end
  end
end
