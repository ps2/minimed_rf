
module MinimedRF
  class FindDevice < Message

    # a235053509349999990041
    def self.bit_blocks
      {
        flag: [0,1],
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
      "FindDevice: #{b(:flag)} ##{sequence} #{broadcast_address}"
    end
  end
end
