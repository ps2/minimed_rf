module MinimedRF
  class WakeUp < Message

    def self.bit_blocks
      {
      }
    end

    def arg_count
      d(0)
    end

    def minutes
      d(2)
    end

    def to_s
      if arg_count > 0
        "WakeUp minutes=#{minutes}"
      else
        "WakeUp"
      end
    end
  end
end
