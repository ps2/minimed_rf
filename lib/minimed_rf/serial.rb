require 'serialport'

module MinimedRF
  class SerialRL

    CMD_GET_STATE = 1
    CMD_GET_VERSION = 2
    CMD_SET_CHANNEL = 3
    CMD_GET_PACKET = 4
    CMD_SEND_PACKET = 5


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

    def get_response(timeout=0)
      start = Time.now
      if timeout > 0
        @ser.read_timeout = timeout * 1000
      else
        @ser.read_timeout = 0  # Wait for data
      end

      while 1
        @buf += @ser.readpartial(4096)
        eop = @buf.bytes.index(0)
        if eop
          r = @buf.byteslice(0,eop)
          @buf = @buf.byteslice(eop+1..-1)
          return r
        end
        if (timeout > 0) && (Time.now - start > timeout)
          puts "timed out"
          return nil
        end
      end
    end

    def get_packet
      data = do_command(CMD_GET_PACKET)
      if data.bytesize > 2
        #puts "Got data: #{data.unpack("H*")}"
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
      end
    end

    def send_packet(packet, count=1)
      encoded = [packet.encode].pack('H*')
      puts "Sending #{packet.encode}"
      count.times do
        data = do_command(CMD_SEND_PACKET, packet.data)
      end
    end

    def sync
      while 1
        send_command(CMD_GET_STATE)
        data = get_response(1)
        if data == "OK"
          puts "RileyLink " + data
          break
        end
        puts "retry"
      end

      while 1
        send_command(CMD_GET_VERSION)
        data = get_response(1)
        if data.bytesize >= 3
          puts "Version: " + data
          break
        end
        puts "retry"
      end
    end
  end
end
