
module MinimedRF
  module PumpEvents
    class BolusNormal < Base

      def self.event_type_code
        0x01
      end

      attr_accessor :unabsorbed_insulin_records, :amount, :programmed_amount, :unabsorbed, :type, :duration, :unabsorbed_insulin_total

      def initialize(data, pump_model=nil)
        super(data, pump_model)

        return if @data.bytesize < bytesize

        if @pump_model.larger
          @amount = insulin_decode(d(3), d(4))
          @programmed_amount = insulin_decode(d(1), d(2))
          @unabsorbed_insulin_total = insulin_decode(d(5), d(6))
          @duration = d(7) * 30
        else
          @amount = d(2)/10.0
          @programmed_amount = d(1)/10.0
          @duration = d(3) * 30
        end
        @type = @duration > 0 ? "square" : "normal"
      end

      def bytesize
        if @pump_model.larger
          13
        else
          9
        end
      end

      def insulin_decode(a, b)
        ((a << 8) + b) / 40.0
      end

      def to_s
        "BolusNormal #{timestamp_str} #{amount} #{programmed_amount} #{unabsorbed_insulin_total}"
      end

      def timestamp
        if @pump_model.larger
          parse_date(8)
        else
          parse_date(4)
        end
      end

      def valid_for(date_range)
        super && amount < 30 && programmed_amount < 30
      end

      def as_json
        json = super.merge({
          amount: amount,
          programmed: programmed_amount,
          type: type
        })
        if !unabsorbed_insulin_records.nil?
          json[:appended] = unabsorbed_insulin_records.as_json
        end
        if !unabsorbed_insulin_total.nil?
          json[:unabsorbed] = unabsorbed_insulin_total
        end
        if !duration.nil?
          json[:duration] = duration
        end
        json
      end

    end
  end
end
