module MinimedRF
  class Packet
    attr_accessor :address, :body, :crc, :raw_data, :message_type, :channel, :capture_time, :coding_errors, :packet_type

    def initialize
      coding_errors = 0
    end

    def raw_hex_data
      @raw_data.unpack('H*').first
    end

    def data=(data)
      # Packet type (first byte of packet):
      # 0xa2 (162) = pump <-> mysentry, alerts
      # 0xa5 (165) = glucose meter (bayer contour)
      # 0xa7 (167) = pump dump (from bayer contour nextlink)

      @packet_type = data.getbyte(0)

      @address = data.byteslice(1,3).unpack("H*").first

      @message_type = data.getbyte(4)

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
      @raw_data.length > 4 &&
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
      codes = []
      @raw_data.bytes.each { |b|
        codes << CODES[(b >> 4)]
        codes << CODES[b & 0xf]
      }
      # aaaaaabb bbbbcccc ccdddddd
      bits = codes.map {|code| "%06b" % code}.join + "000000000000"
      output = ""
      bits.scan(/.{8}/).each do |byte_bits|
        output << "%02x" % Integer("0b"+byte_bits)
      end
      output
    end

    def local_capture_time
      capture_time ? capture_time.localtime : nil
    end

    def to_s
      msg = to_message
      if msg
        "#{"%02x" % @packet_type} #{address} #{msg}"
      elsif valid?
        "#{"%02x" % @packet_type} #{address} #{"%02x" % message_type} #{body.unpack("H*").first} #{"%02x" % crc} "
      elsif raw_data
        "invalid: #{raw_data.unpack("H*").first}"
      else
        "invalid: encoding errors"
      end
    end

    def to_message
      if valid?
        case packet_type
        when 0xa2
          if MessageTypeMap.include?(message_type)
            MessageTypeMap[message_type].new(raw_data[5..-2])
          end
        when 0xa5

          MinimedRF::Meter.new(raw_data[4..-2])
        end
      end
    end

    def self.from_hex(hex)
      p = Packet.new
      p.data = [hex].pack('H*')
      p
    end

    def self.decode_from_radio(hex_str)
      p = Packet.new
      coding_errors = 0
      radio_bytes = [hex_str].pack('H*').bytes
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
