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
        d(1)
      end

      def to_s
        "UnabsorbedInsulin #{records.map {|r| "(#{r})"}.join(" ")}"
      end

      def records
        (0..(num_records-1)).to_a.map do |idx|
          record_for_idx(idx)
        end
      end

      def record_for_idx(idx)
        record = Record.new
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

    end
  end
end
