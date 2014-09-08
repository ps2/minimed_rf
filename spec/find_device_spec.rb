require 'spec_helper'

describe MinimedRF::FindDevice do

  it "should decode fields" do
    message = MinimedRF::FindDevice.from_hex("3499999900")
    expect(message.sequence).to eq 52
    expect(message.broadcast_address).to eq "999999"
  end

end
