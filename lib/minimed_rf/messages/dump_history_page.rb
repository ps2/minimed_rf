module MinimedRF
  class DumpHistoryPage < Message
    # a7 350535 5d 00 48
    def self.bit_blocks
      {
        last_frame_flag: [0,1],
        frame_number: [1,7]
      }
    end

    def frame_number
      b(:frame_number)
    end

    def frame_data
      @data[1..-1]
    end

    def last_frame_flag
      b(:last_frame_flag) == 1
    end

    def frame_data_hex
      frame_data.unpack("H*").first
    end

    def to_s
      "DumpHistoryPage frame:#{frame_number} data:#{frame_data_hex} lastframe:#{last_frame_flag}"
    end
  end
end
