require 'spec_helper'

describe MinimedRF::Meter do

  it "should decode fields" do
    hex_data = "a6411525885d46"
    packet = MinimedRF::Packet.from_hex(hex_data)
    message = packet.to_message

    expect(message.class).to eq MinimedRF::Remote
    expect(message.remote_id).to eq "411525"
    expect(message.button).to eq "B"
    expect(message.sequence).to eq 93
  end

end
