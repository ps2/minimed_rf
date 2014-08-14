module MinimedRF
  class Message

    def initialize(data)
      @bits = data.unpack("B*").first
    end

    def self.from_hex(hex_str)
      new([hex_str].pack('H*'))
    end

    def b(name)
      range = bit_blocks[name]
      raise "Unknown bit block: #{name}" if range.nil?
      #puts "b(#{name.inspect}) = #{range}"
      Integer("0b" + @bits.send("[]", *range))
    end

    def print_unused_bits
      blocks = bit_blocks.values.sort_by {|b| b.first}
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
  end
end
