require 'minimed_rf'
require 'open-uri'

namespace :history do
  desc "Compare history records to decocare"
  task :decocare_compare do

    type_registry = MinimedRF::HistoryPage.type_registry

    decocare_list = 'https://gist.githubusercontent.com/bewest/b531b24763ff172ee49b/raw/8b2ee96da1a6d491eca1c640601bffb223545ab4/history.txt'
    open(decocare_list).read.each_line do |line|
      model, details = line.chomp.split(':')
      name, code, head, date, body = details.split
      decocare_len = head.to_i + date.to_i + body.to_i
      h_type = type_registry[code.to_i]
      code = "0x%02x" % code.to_i
      if h_type.nil?
        puts "#{code} - #{model}/#{name} (#{decocare_len}) -> ***MISSING***"
      else
        mmrf_len = h_type.new("\x00\x00", MinimedRF::Model522.new).length
        mmrf_name = h_type.to_s.split("::").last
        puts "#{code} - #{model}/#{name} (#{decocare_len}) -> #{mmrf_name} (#{mmrf_len})"
      end
    end
  end
end
