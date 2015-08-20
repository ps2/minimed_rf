#!/usr/bin/env ruby

require 'minimed_rf'

module MinimedRF
  class Message
    def self.descendants
      ObjectSpace.each_object(Class).select { |klass| klass < self }
    end
  end
end

message_types = MinimedRF::Message.descendants.map {|c| c.to_s}.sort

message_types.each do |message_type|
  class_name = message_type.split('::').last
  message_class = MinimedRF.const_get(class_name)
  File.open("docs/#{class_name}.packetdiag", "w") do |f|
    f.write(message_class.packetdiag)
  end
  `packetdiag -T svg docs/#{class_name}.packetdiag`
end

File.open('docs/README.md', "w") do |f|
  f.write("# Packet Diagrams\n")
  message_types.each do |message_type|
    class_name = message_type.split('::').last
    message_class = MinimedRF.const_get(class_name)
    f.write("## #{class_name}\n")
    filename = File.basename(message_class.method(:bit_blocks).source_location.first)
    f.write("[#{filename}](https://github.com/ps2/minimed_rf/blob/master/lib/minimed_rf/messages/#{filename})")
    f.write("![#{class_name}](https://rawgit.com/ps2/minimed_rf/master/docs/#{class_name}.svg)\n\n")
  end
end
