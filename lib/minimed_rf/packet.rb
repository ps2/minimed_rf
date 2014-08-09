module MinimedRF
  class Packet
    attr_accessor :address, :cmd, :body, :crc, :raw_data, :c1, :channel, :capture_time, :coding_errors, :marker

    def initialize
      coding_errors = 0
    end

    def data=(data)
      @marker = data.getbyte(0)
      @address = data.byteslice(1,3).unpack("H*").first
      @c1 = data.getbyte(4)
      @body = data.byteslice(5..-2)
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
      !@raw_data.nil? &&
      (crc.nil? || crc == computed_crc)
    end

    def channel
      @channel || '?'
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

    def local_capture_time
      capture_time ? capture_time.localtime : nil
    end

    def to_s
      rval = ""
      msg_ok = true
      rval = "#{channel} #{local_capture_time} "
      if !crc.nil? && crc != computed_crc
        rval << "#{"%02x" % @marker} #{address} #{"%02x" % c1} #{body.unpack("H*").first} #{"%02x" % crc} "
        rval << "(crc mismatch: 0x#{crc.to_s(16)} != 0x#{computed_crc.to_s(16)}) "
      elsif valid?
        rval << "#{"%02x" % @marker} #{address} #{"%02x" % c1} #{body.unpack("H*").first} #{"%02x" % crc} "
      elsif raw_data
        rval << "invalid: #{raw_data.unpack("H*").first}"
      else
        rval << "no data"
      end
      #rval << ", raw = #{encode.unpack("H*")}"
      rval
    end

    def self.decode_from_radio(bytes)
      p = Packet.new
      coding_errors = 0
      radio_bytes = [bytes].pack('H*').bytes
      bits = radio_bytes.map {|d| "%08b" % d}.join
      decoded_symbols = []
      bits.scan(/.{6}/).each do |word_bits|
        break if word_bits == '000000'
        symbol = CODE_SYMBOLS[word_bits]
        if symbol.nil?
          coding_errors += 1
        else
          decoded_symbols << symbol
        end
      end
      if decoded_symbols.count > 12
        if decoded_symbols.length.odd?
          decoded_symbols = decoded_symbols[0..-2]
        end
        p.data = [decoded_symbols.join].pack("H*")
      end
      p.coding_errors = coding_errors
      p
    end
  end
end
