
module MinimedRF
  class Remote < Message

    # a6 41152 5885d 46
    def self.bit_blocks
      {
      }
    end

    def remote_id
      @data.byteslice(1,3).unpack("H*").first
    end

    def button
      case d(4)
      when 0x86
        "ACT"
      when 0x81
        "S"
      when 0x88
        "B"
      else
        "?"
      end
    end

    def sequence
      d(5)
    end

    def to_s
      "Remote: #{remote_id} button=#{button} sequence=#{sequence}"
    end
  end
end
