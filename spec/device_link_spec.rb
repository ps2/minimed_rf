require 'spec_helper'

describe MinimedRF::FindDevice do

  it "should decode fields" do
    message = MinimedRF::FindDevice.from_hex("3700069500")
    expect(message.sequence).to eq 55
    expect(message.broadcast_address).to eq "000695"
  end

end
