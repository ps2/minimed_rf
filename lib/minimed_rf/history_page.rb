module MinimedRF
  class HistoryPage
    #6ebf0f050000000000000002be02be640000000000000000000000000000000000000000000000000000000000000000000000007b0180de08010f11220006040c1e80c051410f0c0488c411010f7b018ac411010f11220006040c1eb1e651410f1a008fee11010f060303688fee71010f0c040e400001070c030f4000010764001f4000010717003740000107180080f616080f07000001efa18f0000006ea18f050000000000000001ef01ef64000000000000000000000000000000000000000000000000000000000000000000000000210084f616080f0b6b0080f736a80f030000002085f736080f7b0297f716080f2c1c007b0080c000090f001600070000001ea88f0036166ea88f0500000000000000001e001e6400000000000000000000000000000000006000000000000000000000000000c0000000b07b0180de08090f1122007b0280c016090f2c1c007b0080c0000a0f00160007000002bea98f0000006ea98f050000000000000002be02be640000000000000000000000000000000000000000000000000000000000000000000000007b0180de080a0f1122007b0280c0160a0f2c1c007b0080c0000b0f00160007000002beaa8f0000006eaa8f050000000000000002be02be640000000000000000000000000000000000000000000000000000000000000000000000007b0180de080b0f1122007b0280c0160b0f2c1c007b0080c0000c0f00160007000002beab8f0000006eab8f050000000000000002be02be640000000000000000000000000000000000000000000000000000000000000000000000007b0180de080c0f1122007b0280c0160c0f2c1c007b0080c0000d0f00160007000002beac8f0000006eac8f050000000000000002be02be640000000000000000000000000000000000000000000000000000000000000000000000007b0180de080d0f1122007b0280c0160d0f2c1c007b0080c0000e0f00160007000002bead8f0000006ead8f050000000000000002be02be640000000000000000000000000000000000000000000000000000000000000000000000007b0180de080e0f112200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006bd8
    attr_accessor :data

    def self.type_registry
      rval = {}
      MinimedRF::PumpEvents.constants.each do |event_class|
        klazz = MinimedRF::PumpEvents.const_get(event_class)
        next if klazz == MinimedRF::PumpEvents::Base
        rval[klazz.event_type_code] = klazz
      end
      rval
    end

    def initialize(data, pump_model = Model551.new)
      @registry = self.class.type_registry
      @data = data
      @pump_model = pump_model
    end

    def crc_ok?
      CRC16::compute(data.bytes[0..-3]) == data[-2..-1].unpack('n').first
    end

    def decode(date_range = nil, print = false)

      entries = []
      skipped = ""
      unabsorbed_insulin_record = nil

      while (data && data.size > 0) do
        event = match(date_range)
        if event
          unless skipped.empty?
            if print
              puts "************************************************************** Skipped: " + skipped
            end
            skipped = ""
          end
          if print
            puts event.to_s
          end
          if event.class == PumpEvents::BolusNormal && !unabsorbed_insulin_record.nil?
            event.unabsorbed_insulin_records = unabsorbed_insulin_record
            unabsorbed_insulin_record = nil
          end
          if event.class == PumpEvents::UnabsorbedInsulin
            unabsorbed_insulin_record = event
          else
            entries << event
          end
          @data = data[(event.length)..-1]
        else
          skipped << sprintf("%02X",data.getbyte(0))
          @data = data[1..-1]
        end
      end

      unless skipped.empty? || !print
        puts "Trailing bytes: " + skipped
      end

      return entries
    end

    def match(date_range)
      type = data.getbyte(0)
      klazz = @registry[type]
      if klazz
        event = klazz.new(data, @pump_model)
        if data.length < event.length
          return nil
        end
        return event if date_range.nil? || event.valid_for(date_range)
      end
    end

  end
end
