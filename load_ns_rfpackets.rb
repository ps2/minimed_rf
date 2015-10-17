#!/usr/bin/env ruby

require 'open-uri'
require 'json'
require 'dotenv'
begin
  require 'minimed_rf'
rescue LoadError
  require 'rubygems'
  require 'minimed_rf'
end
require 'openssl'

Dotenv.load

ns_url = ENV["NIGHTSCOUT_URL"] or abort("Please set NIGHTSCOUT_URL environment variable")

count = (ARGV[0] || 100).to_i

if count == 0
  abort("invalid count")
end

uri = URI.parse(ns_url + "/api/v1/entries.json?find[type]=rfpacket&count=#{count}")

packets = JSON.parse(uri.read)

packets.each do |p|
  packet = MinimedRF::Packet.from_hex(p["rfpacket"])
  if !packet.valid?
    puts "Skipping #{p["rfpacket"]}"
    next
  end

  puts "#{p["dateString"]} - #{p["rfpacket"]}"
  m = packet.to_message
  puts "                           " + m.to_s
  #v = m.b(:x1)
  #puts "#{m.to_s} %02x %06b" % [v,v]

  #puts m.b(:x1)
  #puts p["hexBody"]
  #puts m.print_unused_bits

end
