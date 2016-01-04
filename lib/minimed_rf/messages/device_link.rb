
module MinimedRF
  class DeviceLink < Message

    # a23505350a37000695008d
    def self.bit_blocks
      {
        flag: [0,1],
        sequence: [1,7]
      }
    end

    def sequence
      b(:sequence)
    end

    def device_address
      hex_str[2,6]
    end

    def to_s
      "DeviceLink: #{b(:flag)} ##{sequence} #{device_address}"
    end
  end
end
