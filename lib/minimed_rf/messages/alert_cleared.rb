
module MinimedRF
  class AlertCleared < Message

    # 2014-09-08T22:49:10-0500 - a2 597055 02 4a72 81
    def self.bit_blocks
      {
        sequence: [0,8],
        alert_type: [8,8]

      }
    end

    def sequence
      b(:sequence)
    end

    def alert_type
      AlertCodes[b(:alert_type)]
    end

    def to_s
      "DeviceLink: ##{sequence} #{alert_type}"
    end
  end
end
