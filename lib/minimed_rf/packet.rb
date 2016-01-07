module MinimedRF
  class Packet
    attr_accessor :address, :data, :sequence, :rssi, :message_type, :channel, :capture_time, :coding_errors, :packet_type

    def initialize
      coding_errors = 0
    end

    def raw_data
      if @raw_data.nil? && !@data.nil?
        @raw_data = encode
      end
      @raw_data
    end

    def raw_hex_data
      if raw_data
        raw_data.unpack('H*').first
      end
    end

    def hex_data
      if @data
        @data.unpack('H*').first
      end
    end

    def data=(data)
      # Packet type (first byte of packet):
      # 0xa2 (162) = mysentry
      # 0xa5 (165) = glucose meter (bayer contour)
      # 0xa6 (166) = paradigm remote (MMT-503NA)
      # 0xa7 (167) = pump
      # 0xa8 (168) = sensor test
      # 0xaa (170) = sensor
      # 0xab (171) = sensor2

      @packet_type = data.getbyte(0)

      @address = data.byteslice(1,3).unpack("H*").first

      @message_type = data.getbyte(4)

      @data = data

    end

    def packetdiag
      out = "packetdiag {\ncolwidth=32\n"
      bits = ""
      @data.each_byte do |d|
        bits << "%08b" % d
      end
      (0..(bits.length-1)).each do |idx|
        if bits[idx] == "1"
          out << "#{idx}-#{idx}: [color = \"#eeeeee\", style = \"0,1\"]\n"
        end
      end
      out << "}\n"
    end

    def valid?
      !@data.nil? &&
      @data.bytesize > 4 &&
      (crc.nil? || crc == computed_crc)
    end

    def channel
      @channel || '?'
    end

    def crc
      case packet_type
      when 0xa8, 0xaa, 0xab
        (data.bytes[-2] << 8) + data.bytes[-1]
      else
        data.bytes[-1]
      end
    end

    def computed_crc
      case packet_type
      when 0xa8, 0xaa, 0xab
        CRC16::compute(data.bytes[0..-3])
      else
        CRC8::compute(data.bytes[0..-2])
      end
    end

    def encode
      codes = []
      @data.bytes.each { |b|
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
        msg.to_s
      elsif valid?
        data.unpack("H*")
      elsif data
        "invalid: #{data.unpack("H*").first} expected_crc=#{"%02x" % computed_crc}"
      else
        "invalid: encoding errors"
      end
    end

    def to_message
      if valid?
        case packet_type
        when 0xa2,0xa7
          if MessageTypeMap.include?(message_type)
            MessageTypeMap[message_type].new(data[5..-2])
          end
        when 0xa5
          MinimedRF::Meter.new(data[0..-2])
        when 0xa6
          MinimedRF::Remote.new(data[0..-2])
        when 0xa8, 0xaa, 0xab
          MinimedRF::Sensor.new(data)
          # Sensor
        end
      end
    end

    def self.from_hex(hex)
      p = Packet.new
      p.data = [hex].pack('H*')
      p
    end

    def self.from_hex_without_crc(hex)
      data = [hex].pack('H*')
      p = Packet.new
      p.data = (data.bytes << CRC8::compute(data.bytes)).pack("c*")
      p
    end

    def self.decode_from_radio_hex(hex_str)
      decode_from_radio([hex_str].pack('H*'))
    end

    def self.decode_from_radio(data)
      coding_errors = 0
      p = Packet.new
      radio_bytes = data.bytes
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
