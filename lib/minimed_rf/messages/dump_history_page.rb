module MinimedRF
  class DumpHistoryPage < Message
    # a7 350535 5d 00 48
    def self.bit_blocks
      {
      }
    end

    def frame_number
      d(6)
    end

    def frame_data
      @data[1..-1]
    end

    def frame_data_hex
      frame_data.unpack("H*").first
    end

    def to_s
      "DumpHistoryPage frame:#{frame_number} data:#{frame_data_hex}"
    end
  end
end
