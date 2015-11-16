require 'minimed_rf'
require 'minimed_rf/string_utils'

namespace :ios do
  desc "Generate list of history types"
  task :history_types do

    MinimedRF::PumpEvents.constants.each do |event_class|
      klazz = MinimedRF::PumpEvents.const_get(event_class)
      next if klazz == MinimedRF::PumpEvents::Base
      name = klazz.to_s.split("::").last.underscore.upcase
      code = "0x%02x" % klazz.event_type_code
      puts "#define MM_HISTORY_#{name} #{code}"
    end

  end
end
