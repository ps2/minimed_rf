require 'serialport'

module MinimedRF
  class SerialRL

    CMD_GET_STATE = 1
    CMD_GET_VERSION = 2
    CMD_GET_PACKET = 3
    CMD_SEND_PACKET = 4
    CMD_SEND_AND_LISTEN = 5

    def initialize(path)
      @ser = SerialPort.new path
      @ser.baud = 19200
      @ser.flow_control = SerialPort::HARD
      # Non-blocking read
      @ser.read_timeout = -1
      @buf = ""
    end

    def do_command(command, param="")
      send_command(command, param)
      get_response
    end

    def send_command(command, param="")
      #puts "Sending command: #{command.inspect}"
      @ser.write(command.chr)
      if param.bytesize > 0
        @ser.write(param)
      end
    end

    def get_response
      @ser.read_timeout = 0
      while 1
        @buf += @ser.readpartial(4096)
        #puts "Read: #{@buf.unpack("H*")}"
        eop = @buf.bytes.index(0)
        if eop
          r = @buf.byteslice(0,eop)
          @buf = @buf.byteslice(eop+1..-1)
          return r
        end
      end
    end

    def get_packet(channel, timeout = 0)
      args = [channel, timeout >> 8, timeout].pack("c*")
      data = do_command(CMD_GET_PACKET, args)
      #puts "#{Time.now.strftime('%H:%M:%S.%3N')} Raw data: #{data.unpack("H*")}"
      if data.bytesize > 2
        packet = MinimedRF::Packet.decode_from_radio(data.byteslice(2..-1))
        rssi_dec = data.getbyte(0)
        rssi_offset = 73
        if rssi_dec >= 128
          packet.rssi = (( rssi_dec - 256) / 2) - rssi_offset
        else
          packet.rssi = (rssi_dec / 2) - rssi_offset
        end
        packet.sequence = data.getbyte(1)
        packet
      else
        puts "#{Time.now.strftime('%H:%M:%S.%3N')} Timeout"
      end
    end

    def send_packet(data, channel, repeat=0, msec_repeat_delay=0)
      p = MinimedRF::Packet.from_hex_without_crc(data)
      encoded = [p.encode].pack('H*')
      prefix = [channel, repeat, msec_repeat_delay].pack("c*")
      data = do_command(CMD_SEND_PACKET, prefix + encoded)
      #puts "#{Time.now.strftime('%H:%M:%S.%3N')} Sent #{p.encode}"
      data
    end

    def sync
      while 1
        send_command(CMD_GET_STATE)
        data = get_response
        if data == "OK"
          puts "RileyLink " + data
          break
        end
        puts "retry"
      end

      while 1
        send_command(CMD_GET_VERSION)
        data = get_response
        if data.bytesize >= 3
          puts "Version: " + data
          break
        end
        puts "retry"
      end
    end
  end
end
