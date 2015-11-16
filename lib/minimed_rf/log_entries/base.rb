module MinimedRF
  module PumpEvents
    class Base
      def initialize(data, pump=nil)
        @data = data
        @data = @data.byteslice(0,length)
        @pump = pump
      end

      def d(i)
        @data.getbyte(i)
      end

      def data_str
        @data.unpack("H*").first
      end

      def parse_date_2byte(offset)
        day = d(offset) & 0x1f
        month = ((d(offset) & 0xe0) >> 4) + ((d(offset+1) & 0x80) >> 7)
        year = 2000 + (d(offset+1) & 0b1111111)
        [year, month, day, 0, 0, 0]
      end


      def parse_date(offset)
        sec = d(offset) & 0x3f
        min = d(offset+1) & 0x3f
        hour = d(offset+2) & 0x1f
        day = d(offset+3) & 0x1f
        month = ((d(offset) >> 4) & 0xc) + (d(offset+1) >> 6)
        year = 2000 + (d(offset+4) & 0b1111111)
        [year, month, day, hour, min, sec]
      end

      def valid_for(date_range)
        return false if @data.length < length
        begin
          time = Time.new(*timestamp)
          return date_range.cover?(time)
        rescue ArgumentError
          return false
        end
      end

      def timestamp_str
        year, month, day, hour, min, sec = timestamp
        "#{year}/#{month}/#{day} #{"%02d" % hour}:#{"%02d" % min}:#{"%02d" % sec}"
      end




    end
  end
end
