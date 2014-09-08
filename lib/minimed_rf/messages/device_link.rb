
module MinimedRF
  class DeviceLink < Message

    # a23505350a37000695008d
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
      "DeviceLink: ##{sequence} #{device_address}"
    end
  end
end
