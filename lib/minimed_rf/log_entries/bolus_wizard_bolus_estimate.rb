
module MinimedRF
  module PumpEvents
    class BolusWizardBolusEstimate < Base

      attr_accessor :carbohydrates, :blood_glucose, :food_estimate, :correction_estimate,
        :bolus_estimate, :unabsorbed_insulin_total, :bg_target_low, :bg_target_high,
        :insulin_sensitivity, :carb_ratio

      def initialize(data, pump_model=nil)
        super(data, pump_model)

        return if @data.bytesize < bytesize

        if @pump_model.larger
          @carbohydrates = ((d(8) & 0xc) << 6) + d(7)
          @blood_glucose = ((d(8) & 0x3) << 8) + d(1)
          @food_estimate = insulin_decode(d(14), d(15))
          @correction_estimate = (((d(16) & 0b111000) << 5) + d(13)) / 40.0
          @bolus_estimate = insulin_decode(d(19), d(20))
          @unabsorbed_insulin_total = insulin_decode(d(17), d(18))
          @bg_target_low = d(12)
          @bg_target_high = d(21)
          @insulin_sensitivity = d(11)
          @carb_ratio = ((d(9) & 0x7) << 8) + d(10) / 10.0
        else
          @carbohydrates = d(7)
          @blood_glucose = ((d(8) & 0x3) << 8) + d(1)
          @food_estimate = d(13)/10.0
          @correction_estimate = ((d(14) << 8) + d(12)) / 10.0
          @bolus_estimate = d(18)/10.0
          @unabsorbed_insulin_total = d(16)/10.0
          @bg_target_low = d(11)
          @bg_target_high = d(19)
          @insulin_sensitivity = d(10)
          @carb_ratio = d(9)
        end
      end

      def self.event_type_code
        0x5b
      end

      def bytesize
        if @pump_model.larger
          22
        else
          20
        end
      end

      def to_s
        # "#{bolus_type} #{timestamp_str} CH:#{carbohydrates} BG:#{blood_glucose} Carb Ratio:#{carb_ratio} Insulin Sensitivity:#{insulin_sensitivity} Bolus Estimate:#{bolus_estimate} Food Estimate:#{food_estimate} Correction Estimate:#{correction_estimate} Unabsorbed Insulin Total:#{unabsorbed_insulin_total}"
        "#{bolus_type} #{timestamp_str} "
      end

      def insulin_decode(a, b)
        ((a << 8) + b) / 40.0
      end

      def bolus_type
        "BolusWizardBolusEstimate"
      end


      def timestamp
        parse_date(2)
      end

      def as_json
        super.merge({
          bg: blood_glucose,
          bg_target_high: bg_target_high,
          correction_estimate: correction_estimate,
          carb_input: carbohydrates,
          unabsorbed_insulin_total: unabsorbed_insulin_total,
          bolus_estimate: bolus_estimate,
          carb_ratio: carb_ratio,
          food_estimate: food_estimate,
          bg_target_low: bg_target_low,
          sensitivity: insulin_sensitivity
        })
      end

    end
  end
end
