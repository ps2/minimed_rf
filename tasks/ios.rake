require 'minimed_rf'
require 'minimed_rf/string_utils'
require 'erb'


namespace :ios do
  desc "Generate list of history types"
  task :history_types do
    codes = {}
    MinimedRF::PumpEvents.constants.each do |event_class|
      klazz = MinimedRF::PumpEvents.const_get(event_class)
      next if klazz == MinimedRF::PumpEvents::Base
      name = klazz.to_s.split("::").last

      codes[klazz.event_type_code] = name
    end

    codes.keys.sort.each do |k|
      code = "0x%02x" % k
      puts "case #{codes[k]} = #{code}"
    end
    puts ""
    puts "var eventType: PumpEvent.Type {"
    puts "  switch self {"

    codes.keys.sort.each do |k|
      code = "0x%02x" % k
      puts "  case .#{codes[k]}:"
      puts "    return #{codes[k]}PumpEvent.self"
    end
    puts "}"

  end

  desc "Generate Objective-C classes for pump events"
  task :classes, [:output_dir] do |t, args|
    output_dir = args[:output_dir]
    if output_dir.nil?
      raise "Need to supply output directory!"
    end
    template_m = File.read(File.expand_path('../history_entry_objc.m.erb', __FILE__))
    template_h = File.read(File.expand_path('../history_entry_objc.h.erb', __FILE__))
    template_swift = File.read(File.expand_path('../history_entry.swift.erb', __FILE__))
    MinimedRF::PumpEvents.constants.each do |event_class|
      klazz = MinimedRF::PumpEvents.const_get(event_class)
      next if klazz == MinimedRF::PumpEvents::Base
      class_short_name = klazz.to_s.split("::").last
      class_name = class_short_name + "PumpEvent"
      event_type_code = "0x%02x" % klazz.event_type_code
      length = klazz.new("0000", MinimedRF::Model522.new).bytesize
      h_file = output_dir + "/" + class_name + ".h"
      swift_file = output_dir + "/" + class_name + ".swift"
      if !File.exists?(h_file)
        File.open(h_file, "w+") do |f|
          f.write(ERB.new(template_h).result(binding))
        end
      end
      m_file = output_dir + "/" + class_name + ".m"
      if !File.exists?(m_file)
        File.open(m_file, "w+") do |f|
          f.write(ERB.new(template_m).result(binding))
        end
      end
      if !File.exists?(swift_file)
        File.open(swift_file, "w+") do |f|
          f.write(ERB.new(template_swift).result(binding))
        end
      end
    end
  end

end
