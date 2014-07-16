module MinimedRF
  class Packet
    attr_accessor :address, :cmd, :body, :crc, :raw_data, :c1, :c2
    def initialize(data)
      @marker = data.getbyte(0)
      @address = data.byteslice(1,3).unpack("H*").first
      @c1 = data.getbyte(4)
      @c2 = data.getbyte(5)
      @body = data.byteslice(6..-2)
      @crc = data.getbyte(-1)
      @raw_data = data

      @table = [0]
      msbit = 0x80
      polynomial = 0x9b
      t = msbit
      i = 1
      while (i < 256)
        t = ((t << 1) & 0xff) ^ ((t & msbit > 0) ? polynomial : 0)
        t = t & 0xff
        j = 0
        while (j < i)
          @table[i+j] = (@table[j] ^ t) & 0xff
          j = (j + 1) & 0xff
        end
        i = i * 2
      end
    end

    def valid?
      @marker == 0xa7 &&
      (crc.nil? || crc == computed_crc)
    end

    def computed_crc
      running_crc = 0
      raw_data.bytes[0..-2].each do |b|
        running_crc = @table[(running_crc ^ b) & 0xff]
      end
      running_crc
    end

    def encode
      packet = msg_data + [computed_crc].pack('c*')
      codes = []
      packet.bytes.each { |b|
        codes << CODES[(b >> 4)]
        codes << CODES[b & 0xf]
      }
      # aaaaaabb bbbbcccc ccdddddd
      bits = codes.map {|code| "%06b" % code}.join + "010110" + "000000" + "000000" # Add "7-"
      encoded_bytes = []
      bits.scan(/.{8}/).each do |byte_bits|
        encoded_bytes << Integer("0b"+byte_bits)
      end
      encoded_bytes << 0x00
      encoded_bytes.pack('c*')
    end

    def to_s
      rval = ""
      msg_ok = true
      if !crc.nil? && crc != computed_crc
        rval << "(crc mismatch: 0x#{crc.to_s(16)} != 0x#{computed_crc.to_s(16)}) "
      end
      if valid?
        rval << "#{address} #{"%02x" % c1} #{"%02x" % c2} #{body.unpack("H*").first} #{"%02x" % computed_crc} "
      end
      #rval << ", raw = #{encode.unpack("H*")}"
      rval
    end
  end
end
