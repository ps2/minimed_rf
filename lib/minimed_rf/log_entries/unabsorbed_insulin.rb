# 5c0b 2806c0 2892c0 445ad0

module MinimedRF
  module PumpEvents
    class UnabsorbedInsulin < Base

      class Record
        attr_accessor :amount, :age
        def to_s
          "Amount:#{amount} Age:#{age}"
        end
      end

      def self.event_type_code
        0x5c
      end

      def length
        [2, d(1)].max
      end

      def to_s
        return "UnabsorbedInsulin: Invalid" if @data.length < length
        "UnabsorbedInsulin #{records.length} entries, #{records.map(&:amount).inject {|sum,amount| sum + amount}}U total"
      end

      def records
        (0..(num_records-1)).to_a.map do |idx|
          record_for_idx(idx)
        end
      end

      def record_for_idx(idx)
        record = Record.new
        return record if @data.length < length
        record.amount = d(2 + idx * 3) / 40.0
        record.age = d(3 + idx * 3) + ((d(4 + idx * 3) & 0b110000) << 4)
        record
      end

      def num_records
        (d(1) - 2) / 3
      end

      def valid_for(date_range)
        num_records > 0 && num_records < 100
      end

      def as_json
        super.merge({
          data: records.map{|r| {amount: r.amount, age: r.age}}
        })
      end

    end
  end
end
