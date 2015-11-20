module MinimedRF
  class BasePumpModel
    def records_unabsorbed_insulin_on_bolus
      false
    end

    def has_low_suspend
      false
    end

    def strokes_per_unit
      10
    end
  end

  class Model508 < BasePumpModel; end

  class Model511 < Model508; end

  class Model512 < Model511; end

  class Model515 < Model512; end

  class Model522 < Model515; end

  class Model722 < Model522; end

  class Model523 < Model522
    def records_unabsorbed_insulin_on_bolus
      false
    end

    def strokes_per_unit
      10
    end
  end

  class Model723 < Model523; end

  class Model530 < Model523; end

  class Model730 < Model530; end

  class Model540 < Model530; end

  class Model740 < Model540; end

  class Model551 < Model540; end

  class Model751 < Model551; end

  class Model554 < Model551; end

  class Model754 < Model554; end

  Models = {
    '508' => Model508,
    '511' => Model511,
    '512' => Model512,
    '515' => Model515,
    '522' => Model522,
    '523' => Model523,
    '530' => Model530,
    '540' => Model540,
    '551' => Model551,
    '554' => Model554,
    '722' => Model722,
    '723' => Model723,
    '723' => Model723,
    '730' => Model730,
    '740' => Model740,
    '751' => Model751,
    '754' => Model754
  }
end
