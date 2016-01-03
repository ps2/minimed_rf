
module MinimedRF
  class FindDevice < Message

    # a235053509349999990041
    def self.bit_blocks
      {
        sequence: [1,7]
      }
    end

    def sequence
      b(:sequence)
    end

    def broadcast_address
      hex_str[2,6]
    end

    def to_s
      "FindDevice: ##{sequence} #{broadcast_address}"
    end
  end
end
