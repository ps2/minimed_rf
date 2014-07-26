module MinimedRF
  class GlucoseSensorData
    BIT_BLOCKS = {
      minute: [234,6],
      hour: [227,5],
      day: [267,5],
      month: [260, 4],
      year: [248, 8],
      bg_h: [72, 8],
      bg_l: [199, 1]
    }

    def initialize(data)
      @bits = data.unpack("B*").first
    end

    def b(name)
      range = BIT_BLOCKS[name]
      raise "Unknown bit block: #{name}" if range.nil?
      puts "b(#{name.inspect}) = #{range}"
      Integer("0b" + @bits.send("[]", *range))
    end

    def timestamp
      Time.new(b(:year) + 2000, b(:month), b(:day), b(:hour), b(:minute))
    end

    def glucose
      (b(:bg_h) << 1) + b(:bg_l)
    end

    def to_s
      "GlucoseSensorData: #{timestamp} - #{glucose}"
    end
  end
end
