require 'spec_helper'

describe MinimedRF::Packet do
  it "should parse data from radio" do
    radio_data = "ab29595959655743a5d31c7254ec4b54e55a54b555d0dd0e5555716aa563571566c9ac7258e565574555d1c55555555568bc7256c55554e55a54b55555556c55"
    packet = MinimedRF::Packet.decode_from_radio(radio_data)
    expect(packet.address).to eq "597055"
    expect(packet.packet_type).to eq 0xa2
    expect(packet.message_type).to eq 0x04
  end

  it "should accept decoded hex data" do
    hex_data = "a259705504a24117043a0e080b003d3d00015b030105d817790a0f00000300008b1702000e080b000071"
    packet = MinimedRF::Packet.from_hex(hex_data)
    expect(packet.address).to eq "597055"
    expect(packet.packet_type).to eq 0xa2
    expect(packet.message_type).to eq 0x04
  end

  it "should convert to a message" do
    hex_data = "a259705504a24117043a0e080b003d3d00015b030105d817790a0f00000300008b1702000e080b000071"
    packet = MinimedRF::Packet.from_hex(hex_data)
    message = packet.to_message
    expect(message).to be_a MinimedRF::Message
  end

end
