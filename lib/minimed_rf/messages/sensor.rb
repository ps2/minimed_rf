
module MinimedRF
  class Sensor < Message

    # a80f25c1230d191c50008f009000343499000000000000000000000000000000dee7
    def self.bit_blocks
      {
        state: [4,4],
        address: [16,24],
        version: [40,8],
      }
    end

    def state
      case b(:state)
      when 0xb
        "normal"
      when 0xa
        "warm-up"
      when 0x8
        "testing"
      end
    end

    def sequence
      b(:sequence)
    end

    def version
      major = b(:version) / 10
      minor = b(:version) % 10
      "#{major}.#{minor}"
    end

    def device_address
      b(:address)
    end

    def to_s
      "Sensor: #{state} #{device_address} v#{version}"
    end
  end
end
