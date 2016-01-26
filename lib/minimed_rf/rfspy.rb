require 'serialport'

module MinimedRF
  class RFSpy

    CMD_GET_STATE = 1
    CMD_GET_VERSION = 2
    CMD_GET_PACKET = 3
    CMD_SEND_PACKET = 4
    CMD_SEND_AND_LISTEN = 5
    CMD_UPDATE_REGISTER = 6

    REG_FREQ2 = 0x09
    REG_FREQ1 = 0x0A
    REG_FREQ0 = 0x0B
    REG_MDMCFG4 = 0x0C
    REG_MDMCFG3 = 0x0D
    REG_MDMCFG2 = 0x0E
    REG_MDMCFG1 = 0x0F
    REG_MDMCFG0 = 0x10
    REG_AGCCTRL2 = 0x17
    REG_AGCCTRL1 = 0x18
    REG_AGCCTRL0 = 0x19
    REG_FREND1 = 0x1A
    REG_FREND0 = 0x1B

    FREQ_XTAL = 24000000

    def initialize(path)
      @ser = SerialPort.new path
      @ser.baud = 19200
      @ser.flow_control = SerialPort::HARD
      # Non-blocking read
      @ser.read_timeout = -1
      @buf = ""
    end

    def update_register(reg, value)
      args = [reg, value].pack("c*")
      do_command(CMD_UPDATE_REGISTER, args)
    end

    def set_base_freq(freq_mhz)
      val = ((freq_mhz * 1000000)/(FREQ_XTAL/(2**16).to_f)).to_i
      #puts "Updating freq: 0x#{val.to_s(16)}"
      update_register(REG_FREQ0, val & 0xff)
      update_register(REG_FREQ1, (val >> 8) & 0xff)
      update_register(REG_FREQ2, (val >> 16) & 0xff)
    end

    def set_channel_spacing(ch_khz, existing_mdmcfg1)
      chanspc_e, chanspc_m = calc_chanspc(ch_khz)
      update_register(REG_MDMCFG1, existing_mdmcfg1 & 0b11111100 | chanspc_e)
      update_register(REG_MDMCFG0, chanspc_m)
    end

    def calc_chanspc(ch_khz)
      freq_div = (MinimedRF::RFSpy::FREQ_XTAL/(2**18).to_f)
      vals = []
      d = []
      [0,1,2,3].each do |chanspc_e|
        chanspc_m = ((ch_khz*1000)/(freq_div * 2**chanspc_e) - 256).round;
        if chanspc_m >= 0 && chanspc_m < 256
          return chanspc_e, chanspc_m
        end
      end
      raise "#{ch_khz}kHz out of range for CHANSPC"
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

    def response_to_packet(data)
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
        #puts "#{Time.now.strftime('%H:%M:%S.%3N')} Timeout"
      end
    end

    def get_packet(channel, timeout = 0)
      args = [channel, timeout >> 8, timeout].pack("c*")
      data = do_command(CMD_GET_PACKET, args)
      #puts "#{Time.now.strftime('%H:%M:%S.%3N')} Raw data: #{data.unpack("H*")}"
      response_to_packet(data)
    end

    def send_packet(data, channel, repeat=0, msec_repeat_delay=0)
      p = MinimedRF::Packet.from_hex_without_crc(data)
      encoded = [p.encode].pack('H*')
      prefix = [channel, repeat, msec_repeat_delay].pack("c*")
      data = do_command(CMD_SEND_PACKET, prefix + encoded)
      #puts "#{Time.now.strftime('%H:%M:%S.%3N')} Sent #{p.encode}"
      data
    end

    def send_and_listen(data, send_channel, repeat, delay_ms, listen_channel, timeout, retry_count)
      p = MinimedRF::Packet.from_hex_without_crc(data)
      encoded = [p.encode].pack('H*')
      prefix = [send_channel, repeat, delay_ms, listen_channel, timeout >> 8, timeout, retry_count].pack("c*")
      data = do_command(CMD_SEND_AND_LISTEN, prefix + encoded)
      response_to_packet(data)
    end

    def sync
      while 1
        send_command(CMD_GET_STATE)
        data = get_response
        if data == "OK"
          puts "RileyLink " + data
          break
        end
        #puts "retry"
        print_and_flush "."
      end

      while 1
        send_command(CMD_GET_VERSION)
        data = get_response
        if data.bytesize >= 3
          puts "Version: " + data
          break
        end
        #puts "retry"
        print_and_flush "."
      end
    end
  end
end
