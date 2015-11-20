
module MinimedRF
  module PumpEvents
    class BolusNormal < Base

      def self.event_type_code
        0x01
      end

      attr_accessor :unabsorbed_insulin_records, :amount, :programmed_amount, :unabsorbed, :type, :duration, :unabsorbed_insulin_total

      def initialize(data, pump_model=nil)
        super(data, pump_model)

        return if @data.length < length

        if @pump_model.larger
          @amount = insulin_decode(d(1), d(2))
          @programmed_amount = insulin_decode(d(3), d(4))
          @unabsorbed_insulin_total = insulin_decode(d(5), d(6))
          @type = "normal"
        else
          @amount = d(2)/10.0
          @programmed_amount = d(1)/10.0
          @duration = d(3) * 30
          @type = @duration > 0 ? "square" : "normal"
        end
      end

      def length
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
        "#{bolus_type} #{timestamp_str} #{amount} #{programmed_amount} #{unabsorbed_insulin_total}"
      end

      def timestamp
        parse_date(8)
      end



      def bolus_type
        {1 => "BolusNormal"}[d(0)]
      end

      def valid_for(date_range)
        super && amount < 30 && programmed_amount < 30
      end

      def as_json
        json = super.merge({
          amount: amount,
          programmed_amount: programmed_amount,
          unabsorbed_insulin_total: unabsorbed_insulin_total,
        })
        if !unabsorbed_insulin_records.nil?
          json[:unabsorbed_insulin_records] = unabsorbed_insulin_records.as_json
        end
        json
      end

    end
  end
end
