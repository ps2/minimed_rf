require 'colorize'

module MinimedRF
  class GlucoseSensorData
    BIT_BLOCKS = {
      minute: [234,6],
      hour: [227,5],
      day: [267,5],
      month: [260, 4],
      year: [248, 8],
      bg_h: [72, 8],
      bg_l: [199, 1],
      prev_bg_h: [80, 8],
      prev_bg_l: [198, 1]
    }

    def initialize(data)
      @bits = data.unpack("B*").first
    end

    def b(name)
      range = BIT_BLOCKS[name]
      raise "Unknown bit block: #{name}" if range.nil?
      #puts "b(#{name.inspect}) = #{range}"
      Integer("0b" + @bits.send("[]", *range))
    end

    def print_unused_bits
      blocks = BIT_BLOCKS.values.sort_by {|b| b.first}
      idx = 0
      output = []
      blocks.each do |b|
        raise "Invalid range: #{b.inspect}." if b.first < idx
        if idx < b.first
          output << [(idx..(b.first-1)), :unused]
        end
        output << [(b.first)..(b.first+b.last), :used]
        idx = b.first + b.last
      end
      output.each do |block|
        print @bits[block.first].colorize(block.last == :used ? :white : :light_grey)
      end
      print "\n"
      nil
    end

    def timestamp
      Time.new(b(:year) + 2000, b(:month), b(:day), b(:hour), b(:minute))
    end

    def glucose
      (b(:bg_h) << 1) + b(:bg_l)
    end

    def previous_glucose
      (b(:prev_bg_h) << 1) + b(:prev_bg_l)
    end

    def to_s
      "GlucoseSensorData: #{timestamp} - Glucose=#{glucose} PreviousGlucose=#{previous_glucose}"
    end
  end
end
