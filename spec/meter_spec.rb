require 'spec_helper'

describe MinimedRF::Meter do

  it "should decode fields" do
    hex_data = "a5c527ad008e61"
    packet = MinimedRF::Packet.from_hex(hex_data)
    message = packet.to_message
    expect(message.glucose).to eq 142
  end

  it "should decode fields when bg above 255" do
    hex_data = "a5c527ad018e77"
    packet = MinimedRF::Packet.from_hex(hex_data)
    message = packet.to_message
    expect(message.glucose).to eq 398
  end

  it "should decode fields when bg above 255" do
    hex_data = "a5c527ad018e77"
    packet = MinimedRF::Packet.from_hex(hex_data)
    message = packet.to_message
    expect(message.is_ack?).to eq false
  end


end
